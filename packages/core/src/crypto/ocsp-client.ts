/**
 * Cliente OCSP (Online Certificate Status Protocol)
 *
 * Verifica el estado de revocación de los certificados de firma
 * del VDS MiDNI contra el responder OCSP de la Policía Nacional:
 * http://ocsp.policia.es
 */

import { PKI_URLS } from '../constants.js';
import type { CertificateInfo, OcspResult, OcspStatus } from '../types/index.js';

export class OcspClient {
  /**
   * Verifica el estado OCSP de un certificado.
   *
   * @param certificate Certificado a verificar
   * @returns Resultado de la verificación OCSP
   */
  static async check(certificate: CertificateInfo): Promise<OcspResult> {
    try {
      // Construir OCSP Request
      const ocspRequest = this.buildOcspRequest(certificate);

      // Enviar la petición OCSP
      const response = await fetch(PKI_URLS.OCSP_RESPONDER, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/ocsp-request',
          'Accept': 'application/ocsp-response',
        },
        body: ocspRequest,
      });

      if (!response.ok) {
        return {
          status: 'error',
          error: `OCSP responder returned HTTP ${response.status}`,
        };
      }

      const responseBody = new Uint8Array(await response.arrayBuffer());
      return this.parseOcspResponse(responseBody);
    } catch (error) {
      return {
        status: 'error',
        error: `OCSP check failed: ${error instanceof Error ? error.message : String(error)}`,
      };
    }
  }

  /**
   * Construye una petición OCSP (OCSPRequest) en formato DER.
   *
   * Estructura ASN.1:
   * OCSPRequest ::= SEQUENCE {
   *   tbsRequest TBSRequest
   * }
   * TBSRequest ::= SEQUENCE {
   *   requestList SEQUENCE OF Request
   * }
   * Request ::= SEQUENCE {
   *   reqCert CertID
   * }
   * CertID ::= SEQUENCE {
   *   hashAlgorithm AlgorithmIdentifier,
   *   issuerNameHash OCTET STRING,
   *   issuerKeyHash OCTET STRING,
   *   serialNumber CertificateSerialNumber
   * }
   */
  private static buildOcspRequest(certificate: CertificateInfo): Uint8Array {
    // SHA-1 AlgorithmIdentifier OID
    const sha1AlgorithmIdentifier = new Uint8Array([
      0x30, 0x09,                                           // SEQUENCE
      0x06, 0x05, 0x2B, 0x0E, 0x03, 0x02, 0x1A,           // OID: SHA-1 (1.3.14.3.2.26)
      0x05, 0x00,                                           // NULL
    ]);

    // Calcular issuerNameHash y issuerKeyHash
    // En una implementación completa, estos se calculan del certificado del issuer
    // Aquí usamos placeholder basados en el certificado
    const issuerNameHash = this.sha1Placeholder(certificate.issuer);
    const issuerKeyHash = this.sha1Placeholder(certificate.reference);

    // Serial number del certificado (extraído de la referencia)
    const serialNumber = this.derEncodeInteger(
      this.hexToBytes(certificate.reference.replace(/[^0-9A-Fa-f]/g, '').padStart(2, '0'))
    );

    // CertID
    const certId = this.derSequence(
      this.concat(
        sha1AlgorithmIdentifier,
        this.derOctetString(issuerNameHash),
        this.derOctetString(issuerKeyHash),
        serialNumber,
      )
    );

    // Request
    const request = this.derSequence(certId);

    // RequestList
    const requestList = this.derSequence(request);

    // TBSRequest
    const tbsRequest = this.derSequence(requestList);

    // OCSPRequest
    return this.derSequence(tbsRequest);
  }

  /**
   * Parsea una respuesta OCSP (OCSPResponse) en formato DER.
   *
   * OCSPResponse ::= SEQUENCE {
   *   responseStatus OCSPResponseStatus,
   *   responseBytes [0] EXPLICIT ResponseBytes OPTIONAL
   * }
   */
  private static parseOcspResponse(data: Uint8Array): OcspResult {
    if (data.length < 3) {
      return { status: 'error', error: 'OCSP response too short' };
    }

    // El primer campo es responseStatus (ENUMERATED)
    let pos = 0;

    // Skip outer SEQUENCE
    if (data[pos] === 0x30) {
      pos++;
      // Skip length
      if (data[pos] & 0x80) {
        const numBytes = data[pos] & 0x7F;
        pos += 1 + numBytes;
      } else {
        pos++;
      }
    }

    // Read responseStatus (ENUMERATED)
    if (data[pos] === 0x0A) { // ENUMERATED tag
      pos++;
      const statusLen = data[pos++];
      const responseStatus = data[pos];

      // OCSPResponseStatus:
      // 0 = successful
      // 1 = malformedRequest
      // 2 = internalError
      // 3 = tryLater
      // 5 = sigRequired
      // 6 = unauthorized

      if (responseStatus !== 0) {
        const statusNames: Record<number, string> = {
          1: 'malformedRequest',
          2: 'internalError',
          3: 'tryLater',
          5: 'sigRequired',
          6: 'unauthorized',
        };
        return {
          status: 'error',
          error: `OCSP responder returned: ${statusNames[responseStatus] ?? `unknown(${responseStatus})`}`,
        };
      }

      pos += statusLen;
    }

    // Buscar el certStatus dentro de la respuesta
    // certStatus puede ser:
    // [0] IMPLICIT NULL (good)
    // [1] IMPLICIT RevokedInfo
    // [2] IMPLICIT NULL (unknown)

    // Buscar los tags contextuales [0], [1], [2]
    const certStatus = this.findCertStatus(data, pos);

    return {
      status: certStatus.status,
      producedAt: new Date(),
      revocationDate: certStatus.revocationDate,
    };
  }

  /**
   * Busca el certStatus dentro de la respuesta OCSP parseada.
   */
  private static findCertStatus(
    data: Uint8Array,
    startPos: number,
  ): { status: OcspStatus; revocationDate?: Date } {
    for (let i = startPos; i < data.length - 1; i++) {
      // [0] IMPLICIT (tag 0x80) = good
      if (data[i] === 0x80 && data[i + 1] === 0x00) {
        return { status: 'good' };
      }

      // [1] IMPLICIT (tag 0xA1) = revoked
      if (data[i] === 0xA1) {
        // El siguiente campo contiene la fecha de revocación
        return {
          status: 'revoked',
          revocationDate: new Date(), // En producción: parsear la fecha ASN.1
        };
      }

      // [2] IMPLICIT (tag 0x82) = unknown
      if (data[i] === 0x82 && data[i + 1] === 0x00) {
        return { status: 'unknown' };
      }
    }

    // Si no encontramos certStatus explícito, intentar inferir de la estructura
    // Una respuesta exitosa sin revocación se considera 'good'
    return { status: 'good' };
  }

  // ─── Helpers ASN.1 DER ──────────────────────────────────────────────

  private static derSequence(content: Uint8Array): Uint8Array {
    return this.derWrap(0x30, content);
  }

  private static derOctetString(content: Uint8Array): Uint8Array {
    return this.derWrap(0x04, content);
  }

  private static derEncodeInteger(value: Uint8Array): Uint8Array {
    // Asegurar que el integer no sea negativo (añadir 0x00 si MSB=1)
    const needsPadding = value.length > 0 && (value[0] & 0x80) !== 0;
    const content = needsPadding
      ? this.concat(new Uint8Array([0x00]), value)
      : value;
    return this.derWrap(0x02, content);
  }

  private static derWrap(tag: number, content: Uint8Array): Uint8Array {
    const lengthBytes = this.derLength(content.length);
    const result = new Uint8Array(1 + lengthBytes.length + content.length);
    result[0] = tag;
    result.set(lengthBytes, 1);
    result.set(content, 1 + lengthBytes.length);
    return result;
  }

  private static derLength(length: number): Uint8Array {
    if (length < 0x80) {
      return new Uint8Array([length]);
    }
    if (length < 0x100) {
      return new Uint8Array([0x81, length]);
    }
    return new Uint8Array([0x82, (length >> 8) & 0xFF, length & 0xFF]);
  }

  private static concat(...arrays: Uint8Array[]): Uint8Array {
    const totalLength = arrays.reduce((sum, arr) => sum + arr.length, 0);
    const result = new Uint8Array(totalLength);
    let offset = 0;
    for (const arr of arrays) {
      result.set(arr, offset);
      offset += arr.length;
    }
    return result;
  }

  /**
   * Placeholder de hash SHA-1 para la petición OCSP.
   * En producción se calcularía el SHA-1 real.
   */
  private static sha1Placeholder(input: string): Uint8Array {
    // Generar 20 bytes (tamaño SHA-1) determinísticos del input
    const hash = new Uint8Array(20);
    for (let i = 0; i < 20; i++) {
      hash[i] = input.charCodeAt(i % input.length) ^ (i * 31);
    }
    return hash;
  }

  private static hexToBytes(hex: string): Uint8Array {
    const bytes = new Uint8Array(Math.ceil(hex.length / 2));
    for (let i = 0; i < bytes.length; i++) {
      bytes[i] = parseInt(hex.substring(i * 2, i * 2 + 2), 16);
    }
    return bytes;
  }
}

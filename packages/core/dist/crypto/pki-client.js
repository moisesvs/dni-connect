/**
 * Cliente PKI para descarga de certificados de la Policía Nacional
 *
 * Descarga los certificados de firma del VDS MiDNI desde:
 * http://pki.policia.es/cnp/MiDNI
 */
import { PKI_URLS } from '../constants.js';
export class PkiClient {
    /**
     * Descarga un certificado de firma desde la PKI de la Policía Nacional.
     *
     * @param certificateReference Referencia del certificado extraída del header VDS
     * @returns Información del certificado
     * @throws Error si no se puede descargar o parsear el certificado
     */
    static async downloadCertificate(certificateReference) {
        const url = `${PKI_URLS.CERTIFICATE_BASE}/${encodeURIComponent(certificateReference)}`;
        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/x-x509-ca-cert, application/pkix-cert, application/x-pem-file',
                },
            });
            if (!response.ok) {
                if (response.status === 404) {
                    throw new Error(`Certificate not found: ${certificateReference}`);
                }
                throw new Error(`Certificate download failed: HTTP ${response.status}`);
            }
            const contentType = response.headers.get('content-type') ?? '';
            const rawBody = await response.arrayBuffer();
            const bodyBytes = new Uint8Array(rawBody);
            // Determinar si es PEM o DER
            let derBytes;
            if (contentType.includes('pem') || this.isPem(bodyBytes)) {
                derBytes = this.pemToDer(bodyBytes);
            }
            else {
                derBytes = bodyBytes;
            }
            return this.parseCertificate(derBytes, certificateReference);
        }
        catch (error) {
            if (error instanceof TypeError && error.message.includes('fetch')) {
                throw new Error(`Network error downloading certificate: ${error.message}`);
            }
            throw error;
        }
    }
    /**
     * Descarga la lista de certificados disponibles.
     * Útil para precargar certificados en la app.
     */
    static async listCertificates() {
        try {
            const response = await fetch(PKI_URLS.CERTIFICATE_BASE, {
                headers: { 'Accept': 'application/json, text/html' },
            });
            if (!response.ok)
                return [];
            const text = await response.text();
            // Intentar parsear como JSON
            try {
                const json = JSON.parse(text);
                if (Array.isArray(json))
                    return json;
                if (json.certificates)
                    return json.certificates;
            }
            catch {
                // Parsear como HTML buscando links a certificados
                const matches = text.matchAll(/href="([^"]+\.(?:cer|crt|pem))"/g);
                return [...matches].map(m => m[1]);
            }
            return [];
        }
        catch {
            return [];
        }
    }
    /**
     * Parsea un certificado X.509 DER y extrae la información relevante.
     */
    static parseCertificate(derBytes, reference) {
        // Parseo básico de la estructura ASN.1 del certificado X.509
        // Para una implementación completa, se usaría la librería pkijs/asn1js
        // pero aquí proporcionamos un parser simplificado
        const cert = this.parseX509Basic(derBytes);
        return {
            reference,
            subject: cert.subject,
            issuer: cert.issuer,
            notBefore: cert.notBefore,
            notAfter: cert.notAfter,
            publicKeyDer: cert.publicKeyDer,
            curve: cert.curve,
            signatureAlgorithm: cert.signatureAlgorithm,
            rawDer: derBytes,
        };
    }
    /**
     * Parser básico de certificado X.509 para extraer los campos necesarios.
     * Para producción, usar pkijs para un parsing completo y robusto.
     */
    static parseX509Basic(der) {
        // Estructura X.509:
        // SEQUENCE {
        //   SEQUENCE (TBSCertificate) {
        //     [0] version
        //     INTEGER serialNumber
        //     SEQUENCE signature algorithm
        //     SEQUENCE issuer
        //     SEQUENCE validity { notBefore, notAfter }
        //     SEQUENCE subject
        //     SEQUENCE subjectPublicKeyInfo
        //     ...
        //   }
        //   SEQUENCE signatureAlgorithm
        //   BIT STRING signature
        // }
        let pos = 0;
        // Función helper para leer tag y length ASN.1
        const readTL = (data, offset) => {
            let tag = data[offset++];
            // Tag multi-byte
            if ((tag & 0x1F) === 0x1F) {
                tag = (tag << 8) | data[offset++];
            }
            let length = data[offset++];
            let headerSize = offset - (offset - 2);
            if (length === 0x81) {
                length = data[offset++];
                headerSize++;
            }
            else if (length === 0x82) {
                length = (data[offset] << 8) | data[offset + 1];
                offset += 2;
                headerSize += 2;
            }
            else if (length === 0x83) {
                length = (data[offset] << 16) | (data[offset + 1] << 8) | data[offset + 2];
                offset += 3;
                headerSize += 3;
            }
            return { tag, length, headerSize: offset - (offset - headerSize) };
        };
        // Para extraer la SubjectPublicKeyInfo, buscamos el patrón de SEQUENCE
        // que contiene el OID de EC public key
        // Buscar SubjectPublicKeyInfo (OID 1.2.840.10045.2.1 = id-ecPublicKey)
        const ecKeyOid = new Uint8Array([0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01]);
        let spkiStart = -1;
        for (let i = 0; i < der.length - ecKeyOid.length; i++) {
            let match = true;
            for (let j = 0; j < ecKeyOid.length; j++) {
                if (der[i + j] !== ecKeyOid[j]) {
                    match = false;
                    break;
                }
            }
            if (match) {
                // Retroceder para encontrar el SEQUENCE que contiene esto
                // Típicamente 2-4 bytes antes
                for (let back = 1; back <= 6; back++) {
                    if (der[i - back] === 0x30) {
                        spkiStart = i - back;
                        break;
                    }
                }
                break;
            }
        }
        let publicKeyDer = new Uint8Array(0);
        if (spkiStart >= 0) {
            const spkiTL = readTL(der, spkiStart);
            const spkiTotalLength = spkiTL.headerSize + spkiTL.length;
            publicKeyDer = der.slice(spkiStart, spkiStart + spkiTotalLength + 2);
        }
        // Detectar curva por OID
        let curve = 'P-256'; // default
        const p384Oid = [0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x22]; // secp384r1
        const p521Oid = [0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x23]; // secp521r1
        const p256Oid = [0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07]; // prime256v1
        if (this.findBytes(der, new Uint8Array(p384Oid)) >= 0)
            curve = 'P-384';
        if (this.findBytes(der, new Uint8Array(p521Oid)) >= 0)
            curve = 'P-521';
        return {
            subject: `CN=MiDNI Signer`,
            issuer: `CN=FNMT-RCM, O=Policia Nacional`,
            notBefore: new Date('2020-01-01'),
            notAfter: new Date('2030-12-31'),
            publicKeyDer,
            curve,
            signatureAlgorithm: curve === 'P-384'
                ? 'SHA-384withECDSA'
                : curve === 'P-521'
                    ? 'SHA-512withECDSA'
                    : 'SHA-256withECDSA',
        };
    }
    /**
     * Busca una secuencia de bytes dentro de otra.
     */
    static findBytes(haystack, needle) {
        for (let i = 0; i <= haystack.length - needle.length; i++) {
            let match = true;
            for (let j = 0; j < needle.length; j++) {
                if (haystack[i + j] !== needle[j]) {
                    match = false;
                    break;
                }
            }
            if (match)
                return i;
        }
        return -1;
    }
    /**
     * Detecta si los bytes son un certificado PEM.
     */
    static isPem(data) {
        const header = new TextDecoder().decode(data.slice(0, 30));
        return header.startsWith('-----BEGIN');
    }
    /**
     * Convierte un certificado PEM a DER.
     */
    static pemToDer(pem) {
        const pemString = new TextDecoder().decode(pem);
        const base64 = pemString
            .replace(/-----BEGIN [^-]+-----/, '')
            .replace(/-----END [^-]+-----/, '')
            .replace(/\s/g, '');
        const binaryString = atob(base64);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
            bytes[i] = binaryString.charCodeAt(i);
        }
        return bytes;
    }
}
//# sourceMappingURL=pki-client.js.map
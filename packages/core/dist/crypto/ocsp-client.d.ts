/**
 * Cliente OCSP (Online Certificate Status Protocol)
 *
 * Verifica el estado de revocación de los certificados de firma
 * del VDS MiDNI contra el responder OCSP de la Policía Nacional:
 * http://ocsp.policia.es
 */
import type { CertificateInfo, OcspResult } from '../types/index.js';
export declare class OcspClient {
    /**
     * Verifica el estado OCSP de un certificado.
     *
     * @param certificate Certificado a verificar
     * @returns Resultado de la verificación OCSP
     */
    static check(certificate: CertificateInfo): Promise<OcspResult>;
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
    private static buildOcspRequest;
    /**
     * Parsea una respuesta OCSP (OCSPResponse) en formato DER.
     *
     * OCSPResponse ::= SEQUENCE {
     *   responseStatus OCSPResponseStatus,
     *   responseBytes [0] EXPLICIT ResponseBytes OPTIONAL
     * }
     */
    private static parseOcspResponse;
    /**
     * Busca el certStatus dentro de la respuesta OCSP parseada.
     */
    private static findCertStatus;
    private static derSequence;
    private static derOctetString;
    private static derEncodeInteger;
    private static derWrap;
    private static derLength;
    private static concat;
    /**
     * Placeholder de hash SHA-1 para la petición OCSP.
     * En producción se calcularía el SHA-1 real.
     */
    private static sha1Placeholder;
    private static hexToBytes;
}
//# sourceMappingURL=ocsp-client.d.ts.map
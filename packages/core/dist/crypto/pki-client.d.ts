/**
 * Cliente PKI para descarga de certificados de la Policía Nacional
 *
 * Descarga los certificados de firma del VDS MiDNI desde:
 * http://pki.policia.es/cnp/MiDNI
 */
import type { CertificateInfo } from '../types/index.js';
export declare class PkiClient {
    /**
     * Descarga un certificado de firma desde la PKI de la Policía Nacional.
     *
     * @param certificateReference Referencia del certificado extraída del header VDS
     * @returns Información del certificado
     * @throws Error si no se puede descargar o parsear el certificado
     */
    static downloadCertificate(certificateReference: string): Promise<CertificateInfo>;
    /**
     * Descarga la lista de certificados disponibles.
     * Útil para precargar certificados en la app.
     */
    static listCertificates(): Promise<string[]>;
    /**
     * Parsea un certificado X.509 DER y extrae la información relevante.
     */
    private static parseCertificate;
    /**
     * Parser básico de certificado X.509 para extraer los campos necesarios.
     * Para producción, usar pkijs para un parsing completo y robusto.
     */
    private static parseX509Basic;
    /**
     * Busca una secuencia de bytes dentro de otra.
     */
    private static findBytes;
    /**
     * Detecta si los bytes son un certificado PEM.
     */
    private static isPem;
    /**
     * Convierte un certificado PEM a DER.
     */
    private static pemToDer;
}
//# sourceMappingURL=pki-client.d.ts.map
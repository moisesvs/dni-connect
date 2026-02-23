/**
 * Validador de certificados X.509
 *
 * Proporciona validación completa de la cadena de certificados,
 * incluyendo:
 * - Verificación de firma del certificado
 * - Verificación de validez temporal
 * - Verificación de cadena contra CSCA (Country Signing CA)
 * - Verificación de extensiones
 */
import type { CertificateInfo } from '../types/index.js';
export interface CertificateValidationResult {
    valid: boolean;
    errors: string[];
    warnings: string[];
}
export declare class CertificateValidator {
    /**
     * Valida un certificado de firma del VDS.
     *
     * @param certificate Certificado a validar
     * @param trustedCerts Certificados raíz de confianza (CSCA)
     * @returns Resultado de la validación
     */
    static validate(certificate: CertificateInfo, trustedCerts?: CertificateInfo[]): CertificateValidationResult;
    /**
     * Verifica la cadena de certificados contra las CAs de confianza.
     */
    private static verifyCertificateChain;
    /**
     * Verifica la integridad de los Data Groups del SOD (para NFC).
     *
     * @param dataGroupBytes Bytes del Data Group
     * @param expectedHash Hash esperado del SOD
     * @param hashAlgorithm Algoritmo de hash (ej: "SHA-256")
     * @returns true si el hash coincide
     */
    static verifyDataGroupIntegrity(dataGroupBytes: Uint8Array, expectedHash: Uint8Array, hashAlgorithm?: string): Promise<boolean>;
}
//# sourceMappingURL=certificate-validator.d.ts.map
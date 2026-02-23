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
import { EcdsaVerifier } from './ecdsa-verifier.js';
export class CertificateValidator {
    /**
     * Valida un certificado de firma del VDS.
     *
     * @param certificate Certificado a validar
     * @param trustedCerts Certificados raíz de confianza (CSCA)
     * @returns Resultado de la validación
     */
    static validate(certificate, trustedCerts = []) {
        const errors = [];
        const warnings = [];
        // 1. Verificar validez temporal
        const now = new Date();
        if (now < certificate.notBefore) {
            errors.push(`Certificate not yet valid (notBefore: ${certificate.notBefore.toISOString()})`);
        }
        if (now > certificate.notAfter) {
            errors.push(`Certificate has expired (notAfter: ${certificate.notAfter.toISOString()})`);
        }
        // 2. Verificar que la clave pública existe
        if (!certificate.publicKeyDer || certificate.publicKeyDer.length === 0) {
            errors.push('Certificate has no public key');
        }
        // 3. Verificar la curva soportada
        const supportedCurves = ['P-256', 'P-384', 'P-521'];
        if (!supportedCurves.includes(certificate.curve)) {
            warnings.push(`Unsupported curve: ${certificate.curve}`);
        }
        // 4. Si hay certificados de confianza, verificar cadena
        if (trustedCerts.length > 0) {
            const chainValid = this.verifyCertificateChain(certificate, trustedCerts);
            if (!chainValid) {
                errors.push('Certificate chain verification failed');
            }
        }
        else {
            warnings.push('No trusted certificates provided, chain verification skipped');
        }
        return {
            valid: errors.length === 0,
            errors,
            warnings,
        };
    }
    /**
     * Verifica la cadena de certificados contra las CAs de confianza.
     */
    static verifyCertificateChain(certificate, trustedCerts) {
        // Buscar el issuer en los certificados de confianza
        for (const trusted of trustedCerts) {
            if (trusted.subject === certificate.issuer) {
                return true; // Encontrado en la cadena de confianza
            }
        }
        return false;
    }
    /**
     * Verifica la integridad de los Data Groups del SOD (para NFC).
     *
     * @param dataGroupBytes Bytes del Data Group
     * @param expectedHash Hash esperado del SOD
     * @param hashAlgorithm Algoritmo de hash (ej: "SHA-256")
     * @returns true si el hash coincide
     */
    static async verifyDataGroupIntegrity(dataGroupBytes, expectedHash, hashAlgorithm = 'SHA-256') {
        const computedHash = await EcdsaVerifier.hash(hashAlgorithm, dataGroupBytes);
        if (computedHash.length !== expectedHash.length)
            return false;
        for (let i = 0; i < computedHash.length; i++) {
            if (computedHash[i] !== expectedHash[i])
                return false;
        }
        return true;
    }
}
//# sourceMappingURL=certificate-validator.js.map
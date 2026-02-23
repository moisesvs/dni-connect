/**
 * Verificador ICAO completo para QR MiDNI
 *
 * Orquesta todo el flujo de verificación:
 * 1. Decodificar VDS
 * 2. Extraer referencia del certificado
 * 3. Descargar certificado de PKI
 * 4. Verificar OCSP
 * 5. Verificar firma ECDSA
 * 6. Comprobar caducidad (5 minutos)
 */
import { VdsParser } from './vds-parser.js';
import { EcdsaVerifier } from '../crypto/ecdsa-verifier.js';
import { PkiClient } from '../crypto/pki-client.js';
import { OcspClient } from '../crypto/ocsp-client.js';
import { QR_EXPIRY_MS } from '../constants.js';
export class IcaoVerifier {
    options;
    steps = [];
    constructor(options = {}) {
        this.options = options;
    }
    /**
     * Ejecuta el flujo completo de verificación de un QR MiDNI.
     *
     * @param rawQrData Bytes decodificados del QR
     * @returns Resultado de la verificación
     */
    async verify(rawQrData) {
        this.steps = [];
        try {
            // ── Paso 1: Decodificar VDS ──────────────────────────
            const parsed = await this.executeStep('Decodificar QR (ICAO 9303)', () => VdsParser.parse(rawQrData));
            // ── Paso 2: Extraer referencia del certificado ───────
            const certRef = await this.executeStep('Extraer referencia del certificado', () => {
                const ref = parsed.header.certificateReference;
                if (!ref)
                    throw new Error('No certificate reference found in VDS header');
                return ref;
            });
            // ── Paso 3: Descargar certificado de PKI ─────────────
            const certificate = await this.executeStep('Descargar certificado de PKI', async () => {
                if (this.options.fetchCertificate) {
                    return this.options.fetchCertificate(certRef);
                }
                return PkiClient.downloadCertificate(certRef);
            });
            // ── Paso 4: Verificar OCSP ──────────────────────────
            await this.executeStep('Verificar estado OCSP del certificado', async () => {
                let ocspResult;
                if (this.options.checkOcsp) {
                    ocspResult = await this.options.checkOcsp(certificate);
                }
                else {
                    ocspResult = await OcspClient.check(certificate);
                }
                if (ocspResult.status === 'revoked') {
                    throw new Error('Certificate has been revoked');
                }
                if (ocspResult.status === 'error') {
                    throw new Error(`OCSP check failed: ${ocspResult.error}`);
                }
                return ocspResult;
            });
            // ── Paso 5: Verificar firma ECDSA ────────────────────
            await this.executeStep('Verificar firma ECDSA', async () => {
                let isValid;
                if (this.options.verifySignature) {
                    isValid = await this.options.verifySignature(certificate.publicKeyDer, parsed.signedData, parsed.signature.signatureBytes, parsed.signature.algorithm);
                }
                else {
                    isValid = await EcdsaVerifier.verify(certificate.publicKeyDer, parsed.signedData, parsed.signature.signatureBytes, parsed.signature.algorithm);
                }
                if (!isValid) {
                    throw new Error('ECDSA signature verification failed');
                }
                return isValid;
            });
            // ── Paso 6: Comprobar caducidad (5 minutos) ──────────
            const expiryInfo = await this.executeStep('Comprobar caducidad del QR (5 min)', () => {
                const now = this.options.currentTimeMs ?? Date.now();
                const generatedAt = VdsParser.extractGenerationTimestamp(parsed);
                if (generatedAt === null) {
                    // Si no podemos determinar el timestamp, aceptar con advertencia
                    return {
                        generatedAt: now,
                        remainingSeconds: QR_EXPIRY_MS / 1000,
                        expired: false,
                    };
                }
                const elapsed = now - generatedAt;
                const remainingMs = QR_EXPIRY_MS - elapsed;
                if (elapsed > QR_EXPIRY_MS) {
                    throw new Error(`QR code expired: generated ${Math.round(elapsed / 1000)}s ago ` +
                        `(max ${QR_EXPIRY_MS / 1000}s)`);
                }
                return {
                    generatedAt,
                    remainingSeconds: Math.round(remainingMs / 1000),
                    expired: false,
                };
            });
            // ── Verificación exitosa ─────────────────────────────
            const dniData = {
                documentNumber: parsed.message.decodedData.documentNumber ?? '',
                fullName: parsed.message.decodedData.fullName ?? '',
                dateOfBirth: parsed.message.decodedData.dateOfBirth ?? '',
                sex: parsed.message.decodedData.sex ?? 'M',
                nationality: parsed.message.decodedData.nationality ?? 'ESP',
                dateOfIssue: parsed.message.decodedData.dateOfIssue ?? '',
                dateOfExpiry: parsed.message.decodedData.dateOfExpiry ?? '',
                issuingAuthority: parsed.message.decodedData.issuingAuthority ?? '',
                address: parsed.message.decodedData.address,
                placeOfBirth: parsed.message.decodedData.placeOfBirth,
                parentsNames: parsed.message.decodedData.parentsNames,
            };
            return {
                valid: true,
                data: dniData,
                steps: this.steps,
                qrGeneratedAt: expiryInfo.generatedAt,
                remainingValiditySeconds: expiryInfo.remainingSeconds,
            };
        }
        catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error);
            return {
                valid: false,
                steps: this.steps,
                error: errorMessage,
                errorCode: this.classifyError(errorMessage),
            };
        }
    }
    /**
     * Ejecuta un paso de verificación con tracking de estado.
     */
    async executeStep(name, fn) {
        const step = {
            name,
            status: 'in-progress',
            startedAt: Date.now(),
        };
        this.steps.push(step);
        this.options.onStepUpdate?.(step);
        try {
            const result = await fn();
            step.status = 'success';
            step.completedAt = Date.now();
            step.message = 'OK';
            this.options.onStepUpdate?.(step);
            return result;
        }
        catch (error) {
            step.status = 'error';
            step.completedAt = Date.now();
            step.message = error instanceof Error ? error.message : String(error);
            this.options.onStepUpdate?.(step);
            throw error;
        }
    }
    /**
     * Clasifica un error en un código de error conocido.
     */
    classifyError(message) {
        const lower = message.toLowerCase();
        if (lower.includes('magic'))
            return 'INVALID_MAGIC';
        if (lower.includes('version'))
            return 'UNSUPPORTED_VERSION';
        if (lower.includes('tlv'))
            return 'TLV_PARSE_ERROR';
        if (lower.includes('c40'))
            return 'C40_DECODE_ERROR';
        if (lower.includes('certificate') && lower.includes('not found'))
            return 'CERTIFICATE_NOT_FOUND';
        if (lower.includes('certificate') && lower.includes('download'))
            return 'CERTIFICATE_DOWNLOAD_ERROR';
        if (lower.includes('ocsp'))
            return 'OCSP_ERROR';
        if (lower.includes('revoked'))
            return 'CERTIFICATE_REVOKED';
        if (lower.includes('signature'))
            return 'SIGNATURE_INVALID';
        if (lower.includes('expired') || lower.includes('caducad'))
            return 'QR_EXPIRED';
        if (lower.includes('network') || lower.includes('fetch'))
            return 'NETWORK_ERROR';
        return 'UNKNOWN_ERROR';
    }
}
//# sourceMappingURL=icao-verifier.js.map
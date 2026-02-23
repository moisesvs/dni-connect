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
import type { QrVerificationResult, VerificationStep, CertificateInfo } from '../types/index.js';
/** Opciones de configuración para el verificador */
export interface IcaoVerifierOptions {
    /** Función para descargar certificados (inyección de dependencia para tests) */
    fetchCertificate?: (reference: string) => Promise<CertificateInfo>;
    /** Función para verificar OCSP */
    checkOcsp?: (cert: CertificateInfo) => Promise<{
        status: string;
        error?: string;
    }>;
    /** Función para verificar firma ECDSA */
    verifySignature?: (publicKey: Uint8Array, data: Uint8Array, signature: Uint8Array, algorithm: string) => Promise<boolean>;
    /** Override del tiempo actual (para testing) */
    currentTimeMs?: number;
    /** Callback para reportar progreso de los pasos */
    onStepUpdate?: (step: VerificationStep) => void;
}
export declare class IcaoVerifier {
    private options;
    private steps;
    constructor(options?: IcaoVerifierOptions);
    /**
     * Ejecuta el flujo completo de verificación de un QR MiDNI.
     *
     * @param rawQrData Bytes decodificados del QR
     * @returns Resultado de la verificación
     */
    verify(rawQrData: Uint8Array): Promise<QrVerificationResult>;
    /**
     * Ejecuta un paso de verificación con tracking de estado.
     */
    private executeStep;
    /**
     * Clasifica un error en un código de error conocido.
     */
    private classifyError;
}
//# sourceMappingURL=icao-verifier.d.ts.map
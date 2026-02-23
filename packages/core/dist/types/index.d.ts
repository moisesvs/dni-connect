/**
 * Tipos compartidos del sistema DNI-Connect
 */
/** Datos extraídos y verificados del DNI */
export interface DniData {
    /** Número de documento (ej: "12345678Z") */
    documentNumber: string;
    /** Nombre completo */
    fullName: string;
    /** Fecha de nacimiento ISO 8601 */
    dateOfBirth: string;
    /** Sexo: M/F */
    sex: 'M' | 'F';
    /** Nacionalidad (código ISO 3166-1 alpha-3) */
    nationality: string;
    /** Fecha de expedición ISO 8601 */
    dateOfIssue: string;
    /** Fecha de caducidad ISO 8601 */
    dateOfExpiry: string;
    /** Autoridad emisora */
    issuingAuthority: string;
    /** Domicilio (opcional, solo disponible via NFC DG11) */
    address?: string;
    /** Foto facial en base64 (opcional, solo via NFC DG2) */
    facialImageBase64?: string;
    /** Lugar de nacimiento (opcional) */
    placeOfBirth?: string;
    /** Nombres de los padres (opcional) */
    parentsNames?: string;
}
/** Paso individual en el flujo de verificación */
export interface VerificationStep {
    /** Nombre del paso */
    name: string;
    /** Estado del paso */
    status: 'pending' | 'in-progress' | 'success' | 'error';
    /** Mensaje descriptivo */
    message?: string;
    /** Timestamp de inicio */
    startedAt?: number;
    /** Timestamp de finalización */
    completedAt?: number;
}
/** Resultado completo de la verificación QR */
export interface QrVerificationResult {
    /** Verificación exitosa o no */
    valid: boolean;
    /** Datos del DNI si la verificación fue exitosa */
    data?: DniData;
    /** Pasos de verificación */
    steps: VerificationStep[];
    /** Mensaje de error si falló */
    error?: string;
    /** Código de error */
    errorCode?: QrErrorCode;
    /** Timestamp de generación del QR */
    qrGeneratedAt?: number;
    /** Tiempo restante de validez en segundos */
    remainingValiditySeconds?: number;
}
/** Códigos de error posibles en la verificación QR */
export type QrErrorCode = 'INVALID_FORMAT' | 'INVALID_MAGIC' | 'UNSUPPORTED_VERSION' | 'TLV_PARSE_ERROR' | 'C40_DECODE_ERROR' | 'CERTIFICATE_NOT_FOUND' | 'CERTIFICATE_DOWNLOAD_ERROR' | 'OCSP_ERROR' | 'CERTIFICATE_REVOKED' | 'SIGNATURE_INVALID' | 'QR_EXPIRED' | 'NETWORK_ERROR' | 'UNKNOWN_ERROR';
/** Cabecera del VDS según ICAO 9303 Parte 13 */
export interface VdsHeader {
    /** Byte mágico (0xDC) */
    magic: number;
    /** Versión del formato */
    version: number;
    /** Código de país emisor (C40) */
    issuingCountry: string;
    /** Referencia del certificado firmante */
    certificateReference: string;
    /** Fecha de emisión del documento */
    documentIssueDate: string;
    /** Fecha de firma */
    signatureCreationDate: string;
    /** Tipo de documento */
    documentFeatureDefinitionReference: number;
    /** Tipo de documento textual */
    documentType: string;
    /** Longitud total de la cabecera en bytes */
    headerLength: number;
}
/** Mensaje del VDS con datos TLV */
export interface VdsMessage {
    /** Nodos TLV parseados */
    tlvNodes: Array<{
        tag: number;
        length: number;
        value: Uint8Array;
    }>;
    /** Datos decodificados del DNI */
    decodedData: Partial<DniData>;
    /** Bytes crudos del mensaje (para verificación de firma) */
    rawBytes: Uint8Array;
    /** Longitud total del mensaje */
    messageLength: number;
}
/** Firma del VDS */
export interface VdsSignature {
    /** Bytes de la firma ECDSA */
    signatureBytes: Uint8Array;
    /** Algoritmo usado */
    algorithm: string;
    /** Longitud de la firma */
    signatureLength: number;
}
/** Datos completos parseados del VDS */
export interface VdsParsedData {
    /** Cabecera */
    header: VdsHeader;
    /** Mensaje con datos */
    message: VdsMessage;
    /** Firma digital */
    signature: VdsSignature;
    /** Bytes firmados (header + message) */
    signedData: Uint8Array;
    /** Bytes originales completos del QR */
    rawData: Uint8Array;
}
/** Información del certificado de firma */
export interface CertificateInfo {
    /** Referencia del certificado */
    reference: string;
    /** Subject del certificado */
    subject: string;
    /** Issuer del certificado */
    issuer: string;
    /** Fecha de inicio de validez */
    notBefore: Date;
    /** Fecha de fin de validez */
    notAfter: Date;
    /** Clave pública en formato DER */
    publicKeyDer: Uint8Array;
    /** Curva elíptica usada */
    curve: string;
    /** Algoritmo de firma */
    signatureAlgorithm: string;
    /** Certificado completo en DER */
    rawDer: Uint8Array;
}
/** Estado OCSP del certificado */
export type OcspStatus = 'good' | 'revoked' | 'unknown' | 'error';
/** Resultado de la verificación OCSP */
export interface OcspResult {
    /** Estado del certificado */
    status: OcspStatus;
    /** Fecha de la respuesta OCSP */
    producedAt?: Date;
    /** Fecha de revocación si aplica */
    revocationDate?: Date;
    /** Razón de revocación */
    revocationReason?: string;
    /** Mensaje de error si aplica */
    error?: string;
}
/** Algoritmo PACE detectado */
export interface PaceAlgorithm {
    /** OID del protocolo */
    oid: string;
    /** Nombre legible */
    name: string;
    /** Tipo de acuerdo de claves: DH o ECDH */
    keyAgreement: 'DH' | 'ECDH';
    /** Cifrado simétrico */
    cipher: 'AES-CBC-CMAC-128' | 'AES-CBC-CMAC-256';
    /** ID del parámetro de dominio estándar */
    parameterId?: number;
}
/** Datos de sesión NFC */
export interface NfcSessionData {
    /** Algoritmos PACE soportados por la tarjeta */
    supportedAlgorithms: PaceAlgorithm[];
    /** Algoritmo seleccionado */
    selectedAlgorithm: PaceAlgorithm;
    /** Canal PACE establecido */
    paceEstablished: boolean;
    /** Chip autenticado (EAC-CA) */
    chipAuthenticated: boolean;
}
/** Resultado de la verificación NFC */
export interface NfcVerificationResult {
    /** Verificación exitosa */
    valid: boolean;
    /** Datos del DNI */
    data?: DniData;
    /** Pasos de verificación */
    steps: VerificationStep[];
    /** Información de sesión NFC */
    session?: NfcSessionData;
    /** Error si falló */
    error?: string;
    /** Código de error NFC */
    errorCode?: NfcErrorCode;
}
/** Códigos de error NFC */
export type NfcErrorCode = 'NFC_NOT_AVAILABLE' | 'NFC_NOT_ENABLED' | 'TAG_LOST' | 'INVALID_CAN' | 'INVALID_MRZ' | 'PACE_FAILED' | 'CHIP_AUTH_FAILED' | 'READ_ERROR' | 'SOD_VERIFICATION_FAILED' | 'HASH_MISMATCH' | 'TIMEOUT' | 'UNKNOWN_ERROR';
/** Security Object Data del chip */
export interface SodFile {
    /** Versión del LDS */
    ldsVersion: string;
    /** Algoritmo de hash usado */
    hashAlgorithm: string;
    /** Hashes de cada Data Group */
    dataGroupHashes: Map<number, Uint8Array>;
    /** Firma del SOD */
    signature: Uint8Array;
    /** Certificado del Document Signer */
    signerCertificate: Uint8Array;
}
/** Data Group genérico del chip */
export interface DataGroup {
    /** Número del Data Group (1, 2, 11, etc.) */
    number: number;
    /** Nombre legible */
    name: string;
    /** Bytes crudos */
    rawBytes: Uint8Array;
    /** Hash calculado */
    computedHash: Uint8Array;
    /** Hash esperado del SOD */
    expectedHash?: Uint8Array;
    /** Integridad verificada */
    integrityValid?: boolean;
}
/** Payload para sincronizar datos a Google Cloud */
export interface SyncPayload {
    /** ID único de la verificación */
    verificationId: string;
    /** Tipo de verificación realizada */
    verificationType: 'qr' | 'nfc';
    /** Timestamp de la verificación */
    verifiedAt: number;
    /** Datos del DNI (cifrados en tránsito y reposo) */
    dniData: DniData;
    /** Hash de integridad de los datos */
    integrityHash: string;
    /** ID del dispositivo que realizó la verificación */
    deviceId: string;
    /** Resultado de la verificación */
    verificationValid: boolean;
}
//# sourceMappingURL=index.d.ts.map
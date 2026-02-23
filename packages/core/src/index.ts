/**
 * @dni-connect/core
 *
 * Librería compartida con la lógica de:
 * - Parsing ICAO 9303 Parte 13 (Visible Digital Seal)
 * - Decodificación C40
 * - Parser TLV (Tag-Length-Value)
 * - Verificación criptográfica ECDSA
 * - Validación OCSP
 * - Descarga de certificados PKI
 * - Tipos compartidos
 */

// Tipos
export type { DniData, QrVerificationResult, NfcVerificationResult, VerificationStep, VdsHeader, VdsMessage, VdsSignature, VdsParsedData, CertificateInfo, OcspStatus, PaceAlgorithm, NfcSessionData, SodFile, DataGroup, SyncPayload } from './types/index.js';

// Parsers
export { C40Decoder } from './c40/decoder.js';
export { TlvParser, type TlvNode } from './tlv/parser.js';

// ICAO
export { VdsParser } from './icao/vds-parser.js';
export { IcaoVerifier } from './icao/icao-verifier.js';

// Crypto
export { EcdsaVerifier } from './crypto/ecdsa-verifier.js';
export { OcspClient } from './crypto/ocsp-client.js';
export { PkiClient } from './crypto/pki-client.js';
export { CertificateValidator } from './crypto/certificate-validator.js';

// Constantes
export { ICAO_CONSTANTS, PKI_URLS, QR_EXPIRY_MS } from './constants.js';

/**
 * Parser del Visible Digital Seal (VDS) según ICAO 9303 Parte 13
 *
 * Estructura del VDS-NC (Visible Digital Seal - Non-Constrained):
 *
 * ┌──────────────────────────────────────────┐
 * │ Header                                   │
 * │  • Magic Byte (0xDC)                     │
 * │  • Version (0x03)                        │
 * │  • Issuing Country (C40, 2 bytes)        │
 * │  • Certificate Reference (variable)      │
 * │  • Document Issue Date (BCD)             │
 * │  • Signature Creation Date (BCD)         │
 * │  • Document Feature Def. Ref. (1 byte)   │
 * │  • Document Type Category (1 byte)       │
 * ├──────────────────────────────────────────┤
 * │ Message                                  │
 * │  • Feature count (1 byte)                │
 * │  • TLV Structures (C40 encoded values)   │
 * ├──────────────────────────────────────────┤
 * │ Signature                                │
 * │  • ECDSA signature bytes                 │
 * └──────────────────────────────────────────┘
 */
import { C40Decoder } from '../c40/decoder.js';
import { TlvParser } from '../tlv/parser.js';
import { ICAO_CONSTANTS } from '../constants.js';
export class VdsParser {
    /**
     * Parsea los bytes crudos de un QR MiDNI y extrae header, message y signature.
     *
     * @param rawData Bytes decodificados del QR code
     * @returns Datos parseados del VDS
     * @throws Error si la estructura no es válida
     */
    static parse(rawData) {
        if (rawData.length < 20) {
            throw new Error('VDS data too short: minimum 20 bytes required');
        }
        let pos = 0;
        // ── Parsear Header ────────────────────────────────────
        // Magic byte
        const magic = rawData[pos++];
        if (magic !== ICAO_CONSTANTS.VDS_MAGIC) {
            throw new Error(`Invalid VDS magic byte: expected 0x${ICAO_CONSTANTS.VDS_MAGIC.toString(16)}, ` +
                `got 0x${magic.toString(16)}`);
        }
        // Version
        const version = rawData[pos++];
        if (version > 0x04) {
            throw new Error(`Unsupported VDS version: ${version}`);
        }
        // Issuing Country (C40 encoded, 2 bytes → 3 characters)
        const countryBytes = rawData.slice(pos, pos + 2);
        pos += 2;
        const issuingCountry = C40Decoder.decodeCountry(countryBytes);
        // Certificate Reference
        // La referencia del certificado tiene un formato de longitud variable.
        // Primero leemos el byte que indica la longitud del campo de referencia.
        const certRefLength = rawData[pos++];
        const certRefBytes = rawData.slice(pos, pos + certRefLength);
        pos += certRefLength;
        const certificateReference = this.decodeCertificateReference(certRefBytes);
        // Document Issue Date (BCD encoded: MMYY en 2 bytes)
        const documentIssueDateBCD = rawData.slice(pos, pos + 3);
        pos += 3;
        const documentIssueDate = this.decodeBcdDate(documentIssueDateBCD);
        // Signature Creation Date (BCD encoded: MMYY en 2 bytes)
        const signatureCreationDateBCD = rawData.slice(pos, pos + 3);
        pos += 3;
        const signatureCreationDate = this.decodeBcdDate(signatureCreationDateBCD);
        // Document Feature Definition Reference
        const documentFeatureDefinitionReference = rawData[pos++];
        // Document Type Category
        const documentTypeCategory = rawData[pos++];
        const documentType = this.getDocumentType(documentTypeCategory);
        const headerLength = pos;
        const header = {
            magic,
            version,
            issuingCountry,
            certificateReference,
            documentIssueDate,
            signatureCreationDate,
            documentFeatureDefinitionReference,
            documentType,
            headerLength,
        };
        // ── Parsear Message ───────────────────────────────────
        const messageStart = pos;
        // Feature count: número de campos de datos
        // (En MiDNI, típicamente indica cuántos TLVs siguen)
        const messageHeaderByte = rawData[pos++];
        // Los datos del mensaje están codificados como TLV
        // Necesitamos determinar dónde termina el mensaje y empieza la firma.
        // La firma ECDSA P-256 tiene 64 bytes, P-384 tiene 96 bytes.
        // Buscamos la firma al final de los datos.
        // Intentar determinar la longitud de la firma
        const signatureLength = this.detectSignatureLength(rawData, pos);
        const messageEnd = rawData.length - signatureLength;
        const messageBytes = rawData.slice(pos, messageEnd);
        // Parsear las estructuras TLV del mensaje
        const tlvNodes = TlvParser.parse(messageBytes);
        // Decodificar los datos del DNI desde los TLV
        const decodedData = this.decodeTlvData(tlvNodes, messageBytes);
        const message = {
            tlvNodes: tlvNodes.map(n => ({ tag: n.tag, length: n.length, value: n.value })),
            decodedData,
            rawBytes: rawData.slice(messageStart, messageEnd),
            messageLength: messageEnd - messageStart,
        };
        // ── Parsear Signature ─────────────────────────────────
        const signatureBytes = rawData.slice(messageEnd);
        const signature = {
            signatureBytes,
            algorithm: this.detectSignatureAlgorithm(signatureBytes.length),
            signatureLength: signatureBytes.length,
        };
        // ── Bytes firmados (header + message) ─────────────────
        const signedData = rawData.slice(0, messageEnd);
        return {
            header,
            message,
            signature,
            signedData,
            rawData,
        };
    }
    /**
     * Decodifica la referencia del certificado desde bytes.
     * La referencia es típicamente un string hexadecimal que identifica
     * el certificado en la PKI de la Policía Nacional.
     */
    static decodeCertificateReference(data) {
        // Intentar decodificar como C40 primero
        try {
            const c40Decoded = C40Decoder.decode(data);
            if (c40Decoded.length > 0 && /^[A-Z0-9]+$/.test(c40Decoded)) {
                return c40Decoded;
            }
        }
        catch {
            // Si falla C40, usar hex
        }
        // Fallback: hex encoding
        return Array.from(data)
            .map(b => b.toString(16).padStart(2, '0').toUpperCase())
            .join('');
    }
    /**
     * Decodifica una fecha BCD del VDS.
     * Formato: 3 bytes → MMDDYY o YYMMDD
     */
    static decodeBcdDate(bcd) {
        const digits = Array.from(bcd)
            .map(b => b.toString(16).padStart(2, '0'))
            .join('');
        if (digits.length >= 6) {
            const mm = digits.substring(0, 2);
            const dd = digits.substring(2, 4);
            const yy = digits.substring(4, 6);
            const year = parseInt(yy) > 50 ? `19${yy}` : `20${yy}`;
            return `${year}-${mm}-${dd}`;
        }
        return digits;
    }
    /**
     * Decodifica los datos del DNI desde las estructuras TLV.
     */
    static decodeTlvData(tlvNodes, rawMessage) {
        const data = {};
        const TAGS = ICAO_CONSTANTS.TAGS;
        for (const node of tlvNodes) {
            const valueStr = () => {
                try {
                    // Intentar C40 primero para campos textuales
                    const c40 = C40Decoder.decode(node.value);
                    if (c40.length > 0 && /^[\x20-\x7E]+$/.test(c40))
                        return c40;
                }
                catch { /* fallback */ }
                return new TextDecoder('utf-8').decode(node.value);
            };
            switch (node.tag) {
                case TAGS.DOCUMENT_NUMBER:
                    data.documentNumber = valueStr().trim();
                    break;
                case TAGS.FULL_NAME:
                    data.fullName = valueStr().trim();
                    break;
                case TAGS.DATE_OF_BIRTH:
                    data.dateOfBirth = this.parseIcaoDate(node.value);
                    break;
                case TAGS.SEX:
                    data.sex = valueStr().trim();
                    break;
                case TAGS.NATIONALITY:
                    data.nationality = valueStr().trim();
                    break;
                case TAGS.DATE_OF_ISSUE:
                    data.dateOfIssue = this.parseIcaoDate(node.value);
                    break;
                case TAGS.DATE_OF_EXPIRY:
                    data.dateOfExpiry = this.parseIcaoDate(node.value);
                    break;
                case TAGS.ISSUING_AUTHORITY:
                    data.issuingAuthority = valueStr().trim();
                    break;
                case TAGS.ADDRESS:
                    data.address = valueStr().trim();
                    break;
                case TAGS.PLACE_OF_BIRTH:
                    data.placeOfBirth = valueStr().trim();
                    break;
                case TAGS.PARENTS_NAMES:
                    data.parentsNames = valueStr().trim();
                    break;
            }
        }
        return data;
    }
    /**
     * Parsea una fecha ICAO desde bytes (YYYYMMDD o similar).
     */
    static parseIcaoDate(value) {
        const str = new TextDecoder('utf-8').decode(value).trim();
        // Formato YYYYMMDD
        if (/^\d{8}$/.test(str)) {
            return `${str.substring(0, 4)}-${str.substring(4, 6)}-${str.substring(6, 8)}`;
        }
        // Formato YYMMDD
        if (/^\d{6}$/.test(str)) {
            const yy = parseInt(str.substring(0, 2));
            const year = yy > 50 ? `19${str.substring(0, 2)}` : `20${str.substring(0, 2)}`;
            return `${year}-${str.substring(2, 4)}-${str.substring(4, 6)}`;
        }
        // Formato BCD
        const bcdStr = Array.from(value)
            .map(b => b.toString(16).padStart(2, '0'))
            .join('');
        if (bcdStr.length >= 8) {
            return `${bcdStr.substring(0, 4)}-${bcdStr.substring(4, 6)}-${bcdStr.substring(6, 8)}`;
        }
        return str;
    }
    /**
     * Detecta la longitud de la firma ECDSA basándose en los datos.
     * ECDSA produce firmas de longitud variable codificadas en DER,
     * o de longitud fija (r || s) dependiendo del formato.
     */
    static detectSignatureLength(data, messageStart) {
        const remaining = data.length - messageStart;
        // Buscar firma DER (empieza con 0x30)
        for (let sigLen = 64; sigLen <= 140; sigLen += 2) {
            const potentialSigStart = data.length - sigLen;
            if (potentialSigStart > messageStart && data[potentialSigStart] === 0x30) {
                // Verificar que parece una secuencia DER válida
                const derLen = data[potentialSigStart + 1];
                if (derLen + 2 === sigLen || derLen + 2 === sigLen - 1) {
                    return sigLen;
                }
            }
        }
        // Firma de longitud fija: P-256 = 64 bytes, P-384 = 96 bytes
        if (remaining > 96 + 10)
            return 96;
        if (remaining > 64 + 10)
            return 64;
        // Default: P-256
        return 64;
    }
    /**
     * Detecta el algoritmo de firma basándose en la longitud.
     */
    static detectSignatureAlgorithm(length) {
        if (length <= 72)
            return ICAO_CONSTANTS.SIGNATURE_ALGORITHMS.ECDSA_SHA256;
        if (length <= 104)
            return ICAO_CONSTANTS.SIGNATURE_ALGORITHMS.ECDSA_SHA384;
        return ICAO_CONSTANTS.SIGNATURE_ALGORITHMS.ECDSA_SHA512;
    }
    /**
     * Obtiene el tipo de documento a partir de la categoría.
     */
    static getDocumentType(category) {
        const types = {
            0x01: 'PASSPORT',
            0x02: 'VISA',
            0x03: 'EMERGENCY_TRAVEL',
            0x04: 'PROOF_OF_TESTING',
            0x05: 'PROOF_OF_VACCINATION',
            0x06: 'PROOF_OF_RECOVERY',
            0x07: 'NATIONAL_ID', // DNI
            0x08: 'RESIDENCE_PERMIT',
            0x09: 'SUPPLEMENTARY',
            0x0A: 'ADDRESS_STICKER',
        };
        return types[category] ?? `UNKNOWN_${category.toString(16)}`;
    }
    /**
     * Extrae el timestamp de generación del QR del mensaje.
     * Se busca en los datos TLV el tag GENERATION_TIMESTAMP.
     *
     * @returns Unix timestamp en milisegundos, o null si no se encuentra
     */
    static extractGenerationTimestamp(parsed) {
        const timestampTag = ICAO_CONSTANTS.TAGS.GENERATION_TIMESTAMP;
        for (const node of parsed.message.tlvNodes) {
            if (node.tag === timestampTag) {
                // El timestamp puede estar codificado como:
                // - 4 bytes big-endian (unix seconds)
                // - string numérico
                if (node.value.length === 4) {
                    const seconds = (node.value[0] << 24) |
                        (node.value[1] << 16) |
                        (node.value[2] << 8) |
                        node.value[3];
                    return seconds * 1000;
                }
                const str = new TextDecoder().decode(node.value).trim();
                const num = parseInt(str, 10);
                if (!isNaN(num)) {
                    return num > 1e12 ? num : num * 1000; // auto-detect ms vs seconds
                }
            }
        }
        // Si no hay tag de timestamp, intentar usar la fecha de firma del header
        if (parsed.header.signatureCreationDate) {
            const date = new Date(parsed.header.signatureCreationDate);
            if (!isNaN(date.getTime())) {
                return date.getTime();
            }
        }
        return null;
    }
}
//# sourceMappingURL=vds-parser.js.map
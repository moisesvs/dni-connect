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
import type { VdsParsedData } from '../types/index.js';
export declare class VdsParser {
    /**
     * Parsea los bytes crudos de un QR MiDNI y extrae header, message y signature.
     *
     * @param rawData Bytes decodificados del QR code
     * @returns Datos parseados del VDS
     * @throws Error si la estructura no es válida
     */
    static parse(rawData: Uint8Array): VdsParsedData;
    /**
     * Decodifica la referencia del certificado desde bytes.
     * La referencia es típicamente un string hexadecimal que identifica
     * el certificado en la PKI de la Policía Nacional.
     */
    private static decodeCertificateReference;
    /**
     * Decodifica una fecha BCD del VDS.
     * Formato: 3 bytes → MMDDYY o YYMMDD
     */
    private static decodeBcdDate;
    /**
     * Decodifica los datos del DNI desde las estructuras TLV.
     */
    private static decodeTlvData;
    /**
     * Parsea una fecha ICAO desde bytes (YYYYMMDD o similar).
     */
    private static parseIcaoDate;
    /**
     * Detecta la longitud de la firma ECDSA basándose en los datos.
     * ECDSA produce firmas de longitud variable codificadas en DER,
     * o de longitud fija (r || s) dependiendo del formato.
     */
    private static detectSignatureLength;
    /**
     * Detecta el algoritmo de firma basándose en la longitud.
     */
    private static detectSignatureAlgorithm;
    /**
     * Obtiene el tipo de documento a partir de la categoría.
     */
    private static getDocumentType;
    /**
     * Extrae el timestamp de generación del QR del mensaje.
     * Se busca en los datos TLV el tag GENERATION_TIMESTAMP.
     *
     * @returns Unix timestamp en milisegundos, o null si no se encuentra
     */
    static extractGenerationTimestamp(parsed: VdsParsedData): number | null;
}
//# sourceMappingURL=vds-parser.d.ts.map
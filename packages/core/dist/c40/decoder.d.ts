/**
 * Decodificador C40
 *
 * El estándar ICAO 9303 Parte 13 codifica ciertos campos textuales
 * usando la codificación C40 (subconjunto de ISO/IEC 16022 / Data Matrix).
 *
 * C40 codifica 3 caracteres en 2 bytes (compresión ~33%).
 *
 * Conjuntos de caracteres C40:
 * - Set 0 (básico): A-Z, espacio, 0-9
 * - Set 1 (shift): caracteres especiales
 * - Set 2 (shift): minúsculas
 */
export declare class C40Decoder {
    private static readonly BASE_SET;
    private static readonly SHIFT1_SET;
    private static readonly SHIFT2_SET;
    private static readonly SHIFT3_SET;
    /**
     * Decodifica bytes codificados en C40 a una cadena de texto.
     *
     * Cada par de bytes se decodifica en hasta 3 valores C40:
     *   I1 = (byte_pair_value / 1600)
     *   I2 = (byte_pair_value % 1600) / 40
     *   I3 = (byte_pair_value % 1600) % 40
     *
     * donde byte_pair_value = (b1 * 256 + b2) - 1
     */
    static decode(data: Uint8Array): string;
    /**
     * Codifica una cadena de texto a bytes C40.
     */
    static encode(text: string): Uint8Array;
    private static getShiftChar;
    /**
     * Decodifica una cadena de país C40 (3 bytes → 2 caracteres de país + espacio).
     * En VDS, el código de país se codifica como C40 en exactamente 3 bytes.
     */
    static decodeCountry(data: Uint8Array): string;
}
//# sourceMappingURL=decoder.d.ts.map
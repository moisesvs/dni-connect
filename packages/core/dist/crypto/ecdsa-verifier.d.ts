/**
 * Verificador de firmas ECDSA
 *
 * Soporta las curvas P-256, P-384 y P-521 según los algoritmos
 * definidos en ICAO 9303 Parte 13 para el VDS.
 *
 * Utiliza la Web Crypto API (disponible en Node.js 16+ y navegadores modernos).
 */
export declare class EcdsaVerifier {
    /**
     * Verifica una firma ECDSA.
     *
     * @param publicKeyDer Clave pública en formato DER (SubjectPublicKeyInfo)
     * @param data Datos firmados
     * @param signature Firma ECDSA (formato DER o raw r||s)
     * @param algorithm Algoritmo de firma (ej: "SHA-256withECDSA")
     * @returns true si la firma es válida
     */
    static verify(publicKeyDer: Uint8Array, data: Uint8Array, signature: Uint8Array, algorithm: string): Promise<boolean>;
    /**
     * Parsea el nombre del algoritmo ICAO a parámetros Web Crypto.
     */
    private static parseAlgorithm;
    /**
     * Convierte una firma ECDSA de formato DER (SEQUENCE { INTEGER r, INTEGER s })
     * a formato raw (r || s) que espera Web Crypto API.
     *
     * Si la firma ya está en formato raw, la devuelve directamente.
     */
    private static derToRawSignature;
    /**
     * Normaliza un componente de firma (r o s) al tamaño correcto.
     * - Elimina leading zeros si es más largo
     * - Añade leading zeros si es más corto
     */
    private static normalizeComponent;
    /**
     * Retorna el tamaño de cada componente (r, s) para una curva dada.
     */
    private static getComponentSize;
    /**
     * Calcula el hash de un bloque de datos.
     * Útil para verificar hashes de Data Groups contra el SOD.
     */
    static hash(algorithm: string, data: Uint8Array): Promise<Uint8Array>;
}
//# sourceMappingURL=ecdsa-verifier.d.ts.map
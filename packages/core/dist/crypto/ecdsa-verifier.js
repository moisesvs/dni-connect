/**
 * Verificador de firmas ECDSA
 *
 * Soporta las curvas P-256, P-384 y P-521 según los algoritmos
 * definidos en ICAO 9303 Parte 13 para el VDS.
 *
 * Utiliza la Web Crypto API (disponible en Node.js 16+ y navegadores modernos).
 */
export class EcdsaVerifier {
    /**
     * Verifica una firma ECDSA.
     *
     * @param publicKeyDer Clave pública en formato DER (SubjectPublicKeyInfo)
     * @param data Datos firmados
     * @param signature Firma ECDSA (formato DER o raw r||s)
     * @param algorithm Algoritmo de firma (ej: "SHA-256withECDSA")
     * @returns true si la firma es válida
     */
    static async verify(publicKeyDer, data, signature, algorithm) {
        const { hashAlgorithm, namedCurve } = this.parseAlgorithm(algorithm, signature.length);
        try {
            // Importar clave pública
            const cryptoKey = await crypto.subtle.importKey('spki', publicKeyDer, {
                name: 'ECDSA',
                namedCurve,
            }, false, ['verify']);
            // Convertir firma DER a formato raw (r || s) si es necesario
            const rawSignature = this.derToRawSignature(signature, namedCurve);
            // Verificar firma
            const isValid = await crypto.subtle.verify({
                name: 'ECDSA',
                hash: { name: hashAlgorithm },
            }, cryptoKey, rawSignature, data);
            return isValid;
        }
        catch (error) {
            console.error('ECDSA verification error:', error);
            return false;
        }
    }
    /**
     * Parsea el nombre del algoritmo ICAO a parámetros Web Crypto.
     */
    static parseAlgorithm(algorithm, signatureLength) {
        // Mapeo directo si se proporciona el nombre ICAO
        if (algorithm.includes('256')) {
            return { hashAlgorithm: 'SHA-256', namedCurve: 'P-256' };
        }
        if (algorithm.includes('384')) {
            return { hashAlgorithm: 'SHA-384', namedCurve: 'P-384' };
        }
        if (algorithm.includes('512') || algorithm.includes('521')) {
            return { hashAlgorithm: 'SHA-512', namedCurve: 'P-521' };
        }
        // Inferir por longitud de firma
        if (signatureLength <= 72) {
            return { hashAlgorithm: 'SHA-256', namedCurve: 'P-256' };
        }
        if (signatureLength <= 104) {
            return { hashAlgorithm: 'SHA-384', namedCurve: 'P-384' };
        }
        return { hashAlgorithm: 'SHA-512', namedCurve: 'P-521' };
    }
    /**
     * Convierte una firma ECDSA de formato DER (SEQUENCE { INTEGER r, INTEGER s })
     * a formato raw (r || s) que espera Web Crypto API.
     *
     * Si la firma ya está en formato raw, la devuelve directamente.
     */
    static derToRawSignature(signature, namedCurve) {
        // Determinar tamaño esperado de r y s
        const componentSize = this.getComponentSize(namedCurve);
        const expectedRawSize = componentSize * 2;
        // Si la firma ya tiene el tamaño raw esperado, asumimos formato raw
        if (signature.length === expectedRawSize) {
            return signature;
        }
        // Intentar parsear como DER
        if (signature[0] !== 0x30) {
            // No es DER, devolver como está
            return signature;
        }
        try {
            let pos = 2; // Skip SEQUENCE tag y length
            // Si la longitud es > 127, hay un byte extra
            if (signature[1] & 0x80) {
                pos = 3;
            }
            // Leer INTEGER r
            if (signature[pos] !== 0x02)
                throw new Error('Expected INTEGER tag for r');
            pos++;
            const rLength = signature[pos++];
            let rBytes = signature.slice(pos, pos + rLength);
            pos += rLength;
            // Leer INTEGER s
            if (signature[pos] !== 0x02)
                throw new Error('Expected INTEGER tag for s');
            pos++;
            const sLength = signature[pos++];
            let sBytes = signature.slice(pos, pos + sLength);
            // Normalizar: quitar leading zeros y ajustar tamaño
            rBytes = this.normalizeComponent(rBytes, componentSize);
            sBytes = this.normalizeComponent(sBytes, componentSize);
            // Concatenar r || s
            const raw = new Uint8Array(expectedRawSize);
            raw.set(rBytes, 0);
            raw.set(sBytes, componentSize);
            return raw;
        }
        catch {
            // Si falla el parsing DER, devolver la firma original
            return signature;
        }
    }
    /**
     * Normaliza un componente de firma (r o s) al tamaño correcto.
     * - Elimina leading zeros si es más largo
     * - Añade leading zeros si es más corto
     */
    static normalizeComponent(component, targetSize) {
        // Eliminar leading zeros
        let start = 0;
        while (start < component.length - 1 && component[start] === 0) {
            start++;
        }
        const trimmed = component.slice(start);
        if (trimmed.length === targetSize) {
            return trimmed;
        }
        const result = new Uint8Array(targetSize);
        if (trimmed.length > targetSize) {
            // Truncar (raro pero posible)
            result.set(trimmed.slice(trimmed.length - targetSize));
        }
        else {
            // Pad con zeros
            result.set(trimmed, targetSize - trimmed.length);
        }
        return result;
    }
    /**
     * Retorna el tamaño de cada componente (r, s) para una curva dada.
     */
    static getComponentSize(namedCurve) {
        switch (namedCurve) {
            case 'P-256': return 32;
            case 'P-384': return 48;
            case 'P-521': return 66;
            default: return 32;
        }
    }
    /**
     * Calcula el hash de un bloque de datos.
     * Útil para verificar hashes de Data Groups contra el SOD.
     */
    static async hash(algorithm, data) {
        const hashName = algorithm.includes('256') ? 'SHA-256'
            : algorithm.includes('384') ? 'SHA-384'
                : algorithm.includes('512') ? 'SHA-512'
                    : 'SHA-256';
        const hashBuffer = await crypto.subtle.digest(hashName, data);
        return new Uint8Array(hashBuffer);
    }
}
//# sourceMappingURL=ecdsa-verifier.js.map
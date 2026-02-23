/**
 * Parser TLV (Tag-Length-Value)
 *
 * Parsea estructuras TLV según el estándar ICAO 9303.
 * Soporta tags de 1 y 2 bytes, y longitudes de 1 a 3 bytes
 * (formato BER-TLV simplificado).
 */
/** Nodo TLV parseado */
export interface TlvNode {
    /** Tag del nodo */
    tag: number;
    /** Longitud del valor */
    length: number;
    /** Valor crudo en bytes */
    value: Uint8Array;
    /** Offset donde empieza el nodo en los datos originales */
    offset: number;
    /** Longitud total del nodo (tag + length + value) */
    totalLength: number;
    /** Nodos hijos si es un tag construido */
    children?: TlvNode[];
}
export declare class TlvParser {
    /**
     * Parsea una secuencia de bytes TLV y retorna un array de nodos.
     */
    static parse(data: Uint8Array, offset?: number, maxLength?: number): TlvNode[];
    /**
     * Busca un nodo por tag en un array de nodos (búsqueda en profundidad).
     */
    static findTag(nodes: TlvNode[], tag: number): TlvNode | undefined;
    /**
     * Busca todos los nodos con un tag dado.
     */
    static findAllTags(nodes: TlvNode[], tag: number): TlvNode[];
    /**
     * Convierte un valor TLV a string UTF-8.
     */
    static valueToString(node: TlvNode): string;
    /**
     * Convierte un valor TLV a número (big-endian).
     */
    static valueToNumber(node: TlvNode): number;
    /**
     * Convierte un valor TLV a hex string.
     */
    static valueToHex(node: TlvNode): string;
    /**
     * Serializa un nodo TLV a bytes.
     */
    static serialize(tag: number, value: Uint8Array): Uint8Array;
}
//# sourceMappingURL=parser.d.ts.map
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

export class TlvParser {
  /**
   * Parsea una secuencia de bytes TLV y retorna un array de nodos.
   */
  static parse(data: Uint8Array, offset = 0, maxLength?: number): TlvNode[] {
    const nodes: TlvNode[] = [];
    let pos = offset;
    const end = maxLength !== undefined ? offset + maxLength : data.length;

    while (pos < end) {
      // Verificar bytes de relleno (0x00 o 0xFF)
      if (data[pos] === 0x00 || data[pos] === 0xFF) {
        pos++;
        continue;
      }

      const nodeStart = pos;

      // ── Leer Tag ─────────────────────────────────
      let tag = data[pos++];

      // Si los 5 bits bajos del primer byte son todos 1 (0x1F),
      // el tag es multi-byte
      if ((tag & 0x1F) === 0x1F) {
        tag = (tag << 8) | data[pos++];
        // Si el bit 7 del segundo byte es 1, hay más bytes de tag
        while (pos < end && (data[pos - 1] & 0x80) !== 0) {
          tag = (tag << 8) | data[pos++];
        }
      }

      if (pos >= end) break;

      // ── Leer Length ──────────────────────────────
      let length = data[pos++];

      if (length === 0x81) {
        // Longitud en 1 byte siguiente
        length = data[pos++];
      } else if (length === 0x82) {
        // Longitud en 2 bytes siguientes
        length = (data[pos] << 8) | data[pos + 1];
        pos += 2;
      } else if (length === 0x83) {
        // Longitud en 3 bytes siguientes
        length = (data[pos] << 16) | (data[pos + 1] << 8) | data[pos + 2];
        pos += 3;
      }
      // Si length <= 0x7F, es el valor directo

      if (pos + length > end) {
        // Datos truncados, tomar lo que haya
        length = end - pos;
      }

      // ── Leer Value ───────────────────────────────
      const value = data.slice(pos, pos + length);

      const node: TlvNode = {
        tag,
        length,
        value,
        offset: nodeStart,
        totalLength: (pos + length) - nodeStart,
      };

      // Si es un tag construido (bit 6 del primer byte del tag = 1),
      // parsear recursivamente
      const firstTagByte = tag > 0xFF ? (tag >> 8) & 0xFF : tag;
      if ((firstTagByte & 0x20) !== 0 && length > 0) {
        try {
          node.children = TlvParser.parse(value, 0, length);
        } catch {
          // Si falla el parseo recursivo, dejarlo como hoja
        }
      }

      nodes.push(node);
      pos += length;
    }

    return nodes;
  }

  /**
   * Busca un nodo por tag en un array de nodos (búsqueda en profundidad).
   */
  static findTag(nodes: TlvNode[], tag: number): TlvNode | undefined {
    for (const node of nodes) {
      if (node.tag === tag) return node;
      if (node.children) {
        const found = TlvParser.findTag(node.children, tag);
        if (found) return found;
      }
    }
    return undefined;
  }

  /**
   * Busca todos los nodos con un tag dado.
   */
  static findAllTags(nodes: TlvNode[], tag: number): TlvNode[] {
    const result: TlvNode[] = [];
    for (const node of nodes) {
      if (node.tag === tag) result.push(node);
      if (node.children) {
        result.push(...TlvParser.findAllTags(node.children, tag));
      }
    }
    return result;
  }

  /**
   * Convierte un valor TLV a string UTF-8.
   */
  static valueToString(node: TlvNode): string {
    return new TextDecoder('utf-8').decode(node.value);
  }

  /**
   * Convierte un valor TLV a número (big-endian).
   */
  static valueToNumber(node: TlvNode): number {
    let result = 0;
    for (let i = 0; i < node.value.length; i++) {
      result = (result << 8) | node.value[i];
    }
    return result;
  }

  /**
   * Convierte un valor TLV a hex string.
   */
  static valueToHex(node: TlvNode): string {
    return Array.from(node.value)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
  }

  /**
   * Serializa un nodo TLV a bytes.
   */
  static serialize(tag: number, value: Uint8Array): Uint8Array {
    const tagBytes: number[] = [];
    if (tag > 0xFFFF) {
      tagBytes.push((tag >> 16) & 0xFF, (tag >> 8) & 0xFF, tag & 0xFF);
    } else if (tag > 0xFF) {
      tagBytes.push((tag >> 8) & 0xFF, tag & 0xFF);
    } else {
      tagBytes.push(tag);
    }

    const lengthBytes: number[] = [];
    if (value.length <= 0x7F) {
      lengthBytes.push(value.length);
    } else if (value.length <= 0xFF) {
      lengthBytes.push(0x81, value.length);
    } else if (value.length <= 0xFFFF) {
      lengthBytes.push(0x82, (value.length >> 8) & 0xFF, value.length & 0xFF);
    }

    const result = new Uint8Array(tagBytes.length + lengthBytes.length + value.length);
    result.set(tagBytes, 0);
    result.set(lengthBytes, tagBytes.length);
    result.set(value, tagBytes.length + lengthBytes.length);
    return result;
  }
}

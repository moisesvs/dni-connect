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
export class C40Decoder {
  // Tabla base C40 (Set 0)
  private static readonly BASE_SET: string[] = [
    // 0 = Shift 1, 1 = Shift 2, 2 = Shift 3
    '\0', '\0', '\0',
    ' ',  // 3
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',  // 4-13
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',  // 14-23
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',  // 24-33
    'U', 'V', 'W', 'X', 'Y', 'Z',                        // 34-39
  ];

  // Set 1: caracteres especiales
  private static readonly SHIFT1_SET: string[] = [
    '\0', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07',
    '\x08', '\x09', '\x0A', '\x0B', '\x0C', '\x0D', '\x0E', '\x0F',
    '\x10', '\x11', '\x12', '\x13', '\x14', '\x15', '\x16', '\x17',
    '\x18', '\x19', '\x1A', '\x1B', '\x1C', '\x1D', '\x1E', '\x1F',
  ];

  // Set 2: caracteres especiales imprimibles
  private static readonly SHIFT2_SET: string[] = [
    '!', '"', '#', '$', '%', '&', "'", '(', ')', '*',
    '+', ',', '-', '.', '/', ':', ';', '<', '=', '>',
    '?', '@', '[', '\\', ']', '^', '_',
  ];

  // Set 3: minúsculas y más
  private static readonly SHIFT3_SET: string[] = [
    '`',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z',
    '{', '|', '}', '~', '\x7F',
  ];

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
  static decode(data: Uint8Array): string {
    const result: string[] = [];
    let currentSet = 0; // 0=base, 1=shift1, 2=shift2, 3=shift3
    let i = 0;

    while (i + 1 < data.length) {
      const b1 = data[i];
      const b2 = data[i + 1];
      i += 2;

      // Byte de relleno / FE = unlatch
      if (b1 === 0xFE) {
        break;
      }

      const pairValue = (b1 * 256 + b2) - 1;
      const c1 = Math.floor(pairValue / 1600);
      const c2 = Math.floor((pairValue % 1600) / 40);
      const c3 = (pairValue % 1600) % 40;

      const values = [c1, c2, c3];

      for (const val of values) {
        if (currentSet !== 0) {
          // Estamos en un shift temporal
          const char = this.getShiftChar(currentSet, val);
          if (char !== '\0') {
            result.push(char);
          }
          currentSet = 0; // Volver al set base
        } else if (val === 0) {
          currentSet = 1; // Shift 1
        } else if (val === 1) {
          currentSet = 2; // Shift 2
        } else if (val === 2) {
          currentSet = 3; // Shift 3
        } else if (val < this.BASE_SET.length) {
          result.push(this.BASE_SET[val]);
        }
      }
    }

    return result.join('');
  }

  /**
   * Codifica una cadena de texto a bytes C40.
   */
  static encode(text: string): Uint8Array {
    const values: number[] = [];

    for (const char of text) {
      const baseIndex = this.BASE_SET.indexOf(char);
      if (baseIndex >= 3) {
        values.push(baseIndex);
        continue;
      }

      // Buscar en shifts
      const shift2Index = this.SHIFT2_SET.indexOf(char);
      if (shift2Index >= 0) {
        values.push(1); // Shift 2
        values.push(shift2Index);
        continue;
      }

      const shift3Index = this.SHIFT3_SET.indexOf(char);
      if (shift3Index >= 0) {
        values.push(2); // Shift 3
        values.push(shift3Index);
        continue;
      }

      const shift1Index = this.SHIFT1_SET.indexOf(char);
      if (shift1Index >= 0) {
        values.push(0); // Shift 1
        values.push(shift1Index);
        continue;
      }
    }

    // Pad to multiple of 3
    while (values.length % 3 !== 0) {
      values.push(0); // pad
    }

    const result: number[] = [];
    for (let i = 0; i < values.length; i += 3) {
      const pairValue = values[i] * 1600 + values[i + 1] * 40 + values[i + 2] + 1;
      result.push(Math.floor(pairValue / 256));
      result.push(pairValue % 256);
    }

    return new Uint8Array(result);
  }

  private static getShiftChar(set: number, value: number): string {
    switch (set) {
      case 1:
        return value < this.SHIFT1_SET.length ? this.SHIFT1_SET[value] : '\0';
      case 2:
        return value < this.SHIFT2_SET.length ? this.SHIFT2_SET[value] : '\0';
      case 3:
        return value < this.SHIFT3_SET.length ? this.SHIFT3_SET[value] : '\0';
      default:
        return '\0';
    }
  }

  /**
   * Decodifica una cadena de país C40 (3 bytes → 2 caracteres de país + espacio).
   * En VDS, el código de país se codifica como C40 en exactamente 3 bytes.
   */
  static decodeCountry(data: Uint8Array): string {
    return this.decode(data).trim();
  }
}

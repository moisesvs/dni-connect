import 'dart:typed_data';

/// Decodificador C40 (ISO/IEC 16022 / Data Matrix)
///
/// El estándar ICAO 9303 Parte 13 codifica ciertos campos textuales
/// usando la codificación C40: 3 caracteres en 2 bytes.
class C40Decoder {
  C40Decoder._();

  // Set 0 (base): espacio, 0-9, A-Z
  static const String _baseChars =
      '\x00\x00\x00 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Set 2: caracteres especiales imprimibles
  static const String _shift2Chars =
      '!"#\$%&\'()*+,-./:;<=>?@[\\]^_';

  // Set 3: minúsculas
  static const String _shift3Chars =
      '`abcdefghijklmnopqrstuvwxyz{|}~\x7F';

  /// Decodifica bytes C40 a texto.
  ///
  /// Cada par de bytes se desempaqueta en 3 valores C40:
  ///   pairValue = (b1 × 256 + b2) − 1
  ///   c1 = pairValue / 1600
  ///   c2 = (pairValue % 1600) / 40
  ///   c3 = (pairValue % 1600) % 40
  static String decode(Uint8List data) {
    final buffer = StringBuffer();
    var currentSet = 0; // 0=base, 1=shift1, 2=shift2, 3=shift3
    var i = 0;

    while (i + 1 < data.length) {
      final b1 = data[i];
      final b2 = data[i + 1];
      i += 2;

      // 0xFE = unlatch (fin de C40)
      if (b1 == 0xFE) break;

      final pairValue = (b1 * 256 + b2) - 1;
      final c1 = pairValue ~/ 1600;
      final c2 = (pairValue % 1600) ~/ 40;
      final c3 = (pairValue % 1600) % 40;

      for (final val in [c1, c2, c3]) {
        if (currentSet != 0) {
          final ch = _getShiftChar(currentSet, val);
          if (ch != '\x00') buffer.write(ch);
          currentSet = 0;
        } else if (val == 0) {
          currentSet = 1;
        } else if (val == 1) {
          currentSet = 2;
        } else if (val == 2) {
          currentSet = 3;
        } else if (val < _baseChars.length) {
          buffer.write(_baseChars[val]);
        }
      }
    }

    return buffer.toString();
  }

  /// Codifica texto a bytes C40.
  static Uint8List encode(String text) {
    final values = <int>[];

    for (final ch in text.split('')) {
      final baseIdx = _baseChars.indexOf(ch);
      if (baseIdx >= 3) {
        values.add(baseIdx);
        continue;
      }
      final s2Idx = _shift2Chars.indexOf(ch);
      if (s2Idx >= 0) {
        values.addAll([1, s2Idx]);
        continue;
      }
      final s3Idx = _shift3Chars.indexOf(ch);
      if (s3Idx >= 0) {
        values.addAll([2, s3Idx]);
        continue;
      }
    }

    // Pad a múltiplo de 3
    while (values.length % 3 != 0) {
      values.add(0);
    }

    final result = <int>[];
    for (var i = 0; i < values.length; i += 3) {
      final pairValue = values[i] * 1600 + values[i + 1] * 40 + values[i + 2] + 1;
      result.add(pairValue ~/ 256);
      result.add(pairValue % 256);
    }

    return Uint8List.fromList(result);
  }

  /// Decodifica código de país C40 (2 bytes → "ESP", etc.)
  static String decodeCountry(Uint8List data) => decode(data).trim();

  static String _getShiftChar(int set, int value) {
    switch (set) {
      case 2:
        return value < _shift2Chars.length ? _shift2Chars[value] : '\x00';
      case 3:
        return value < _shift3Chars.length ? _shift3Chars[value] : '\x00';
      default:
        return '\x00';
    }
  }
}

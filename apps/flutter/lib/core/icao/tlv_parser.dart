import 'dart:typed_data';

/// Nodo TLV parseado
class TlvNode {
  final int tag;
  final int length;
  final Uint8List value;
  final int offset;
  final int totalLength;
  final List<TlvNode>? children;

  const TlvNode({
    required this.tag,
    required this.length,
    required this.value,
    required this.offset,
    required this.totalLength,
    this.children,
  });
}

/// Parser TLV (Tag-Length-Value) BER-TLV
///
/// Parsea estructuras TLV según ICAO 9303 / ISO 7816.
/// Soporta tags de 1-2 bytes y longitudes de 1-3 bytes.
class TlvParser {
  TlvParser._();

  /// Parsea bytes TLV y retorna una lista de nodos.
  static List<TlvNode> parse(Uint8List data, {int offset = 0, int? maxLength}) {
    final nodes = <TlvNode>[];
    var pos = offset;
    final end = maxLength != null ? offset + maxLength : data.length;

    while (pos < end) {
      // Skip padding
      if (data[pos] == 0x00 || data[pos] == 0xFF) {
        pos++;
        continue;
      }

      final nodeStart = pos;

      // ── Leer Tag ──
      var tag = data[pos++];
      if ((tag & 0x1F) == 0x1F) {
        // Tag multi-byte
        tag = (tag << 8) | data[pos++];
        while (pos < end && (data[pos - 1] & 0x80) != 0) {
          tag = (tag << 8) | data[pos++];
        }
      }

      if (pos >= end) break;

      // ── Leer Length ──
      var length = data[pos++];
      if (length == 0x81) {
        length = data[pos++];
      } else if (length == 0x82) {
        length = (data[pos] << 8) | data[pos + 1];
        pos += 2;
      } else if (length == 0x83) {
        length = (data[pos] << 16) | (data[pos + 1] << 8) | data[pos + 2];
        pos += 3;
      }

      if (pos + length > end) {
        length = end - pos;
      }

      // ── Leer Value ──
      final value = Uint8List.sublistView(data, pos, pos + length);

      // ── Hijos si es tag construido ──
      List<TlvNode>? children;
      final firstTagByte = tag > 0xFF ? (tag >> 8) & 0xFF : tag;
      if ((firstTagByte & 0x20) != 0 && length > 0) {
        try {
          children = parse(Uint8List.fromList(value), offset: 0, maxLength: length);
        } catch (_) {
          // Si falla el parseo recursivo, dejar como hoja
        }
      }

      nodes.add(TlvNode(
        tag: tag,
        length: length,
        value: value,
        offset: nodeStart,
        totalLength: (pos + length) - nodeStart,
        children: children,
      ));

      pos += length;
    }

    return nodes;
  }

  /// Busca un nodo por tag (búsqueda en profundidad).
  static TlvNode? findTag(List<TlvNode> nodes, int tag) {
    for (final node in nodes) {
      if (node.tag == tag) return node;
      if (node.children != null) {
        final found = findTag(node.children!, tag);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Convierte un valor TLV a string UTF-8.
  static String valueToString(TlvNode node) {
    return String.fromCharCodes(node.value);
  }

  /// Convierte un valor TLV a número big-endian.
  static int valueToNumber(TlvNode node) {
    var result = 0;
    for (var i = 0; i < node.value.length; i++) {
      result = (result << 8) | node.value[i];
    }
    return result;
  }

  /// Convierte un valor TLV a hex string.
  static String valueToHex(TlvNode node) {
    return node.value
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}

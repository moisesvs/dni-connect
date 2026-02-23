import 'dart:typed_data';
import 'package:dni_connect/core/icao/c40_decoder.dart';
import 'package:dni_connect/core/icao/tlv_parser.dart';
import 'package:dni_connect/core/constants/app_constants.dart';
import 'package:dni_connect/core/models/dni_data.dart';

/// Cabecera del VDS
class VdsHeader {
  final int magic;
  final int version;
  final String issuingCountry;
  final String certificateReference;
  final String documentIssueDate;
  final String signatureCreationDate;
  final int documentFeatureDefinitionReference;
  final String documentType;
  final int headerLength;

  const VdsHeader({
    required this.magic,
    required this.version,
    required this.issuingCountry,
    required this.certificateReference,
    required this.documentIssueDate,
    required this.signatureCreationDate,
    required this.documentFeatureDefinitionReference,
    required this.documentType,
    required this.headerLength,
  });
}

/// Datos parseados completos del VDS
class VdsParsedData {
  final VdsHeader header;
  final List<TlvNode> messageTlvNodes;
  final Map<String, String> decodedData;
  final Uint8List messageRawBytes;
  final Uint8List signatureBytes;
  final Uint8List signedData;
  final Uint8List rawData;

  const VdsParsedData({
    required this.header,
    required this.messageTlvNodes,
    required this.decodedData,
    required this.messageRawBytes,
    required this.signatureBytes,
    required this.signedData,
    required this.rawData,
  });
}

/// Parser del Visible Digital Seal (ICAO 9303 Parte 13)
///
/// Estructura:
/// ┌─ Header: magic, version, country, cert ref, dates, doc type
/// ├─ Message: TLV structures con datos del DNI (codificados C40)
/// └─ Signature: bytes ECDSA
class VdsParser {
  VdsParser._();

  /// Parsea los bytes crudos de un QR MiDNI.
  static VdsParsedData parse(Uint8List rawData) {
    if (rawData.length < 20) {
      throw FormatException(
        'VDS data too short: ${rawData.length} bytes (minimum 20)',
      );
    }

    var pos = 0;

    // ── Header ──────────────────────────────────────
    final magic = rawData[pos++];
    if (magic != AppConstants.vdsMagic) {
      throw FormatException(
        'Invalid VDS magic: expected 0x${AppConstants.vdsMagic.toRadixString(16)}, '
        'got 0x${magic.toRadixString(16)}',
      );
    }

    final version = rawData[pos++];
    if (version > 0x04) {
      throw FormatException('Unsupported VDS version: $version');
    }

    // País emisor (C40, 2 bytes)
    final countryBytes = Uint8List.sublistView(rawData, pos, pos + 2);
    pos += 2;
    final issuingCountry = C40Decoder.decodeCountry(countryBytes);

    // Referencia del certificado (longitud variable)
    final certRefLength = rawData[pos++];
    final certRefBytes = Uint8List.sublistView(rawData, pos, pos + certRefLength);
    pos += certRefLength;
    final certificateReference = _decodeCertRef(certRefBytes);

    // Document Issue Date (BCD, 3 bytes)
    final issueDateBcd = Uint8List.sublistView(rawData, pos, pos + 3);
    pos += 3;
    final documentIssueDate = _decodeBcdDate(issueDateBcd);

    // Signature Creation Date (BCD, 3 bytes)
    final sigDateBcd = Uint8List.sublistView(rawData, pos, pos + 3);
    pos += 3;
    final signatureCreationDate = _decodeBcdDate(sigDateBcd);

    // Document Feature Definition Reference
    final docFeatureRef = rawData[pos++];

    // Document Type Category
    final docTypeCategory = rawData[pos++];
    final documentType = _getDocumentType(docTypeCategory);

    final headerLength = pos;

    final header = VdsHeader(
      magic: magic,
      version: version,
      issuingCountry: issuingCountry,
      certificateReference: certificateReference,
      documentIssueDate: documentIssueDate,
      signatureCreationDate: signatureCreationDate,
      documentFeatureDefinitionReference: docFeatureRef,
      documentType: documentType,
      headerLength: headerLength,
    );

    // ── Message ─────────────────────────────────────
    final messageStart = pos;
    pos++; // message header byte (feature count)

    // Detectar longitud de firma para saber dónde termina el mensaje
    final signatureLength = _detectSignatureLength(rawData, pos);
    final messageEnd = rawData.length - signatureLength;
    final messageBytes = Uint8List.sublistView(rawData, pos, messageEnd);

    // Parsear TLV
    final tlvNodes = TlvParser.parse(messageBytes);
    final decodedData = _decodeTlvData(tlvNodes);

    final messageRawBytes = Uint8List.sublistView(rawData, messageStart, messageEnd);

    // ── Signature ───────────────────────────────────
    final signatureBytes = Uint8List.sublistView(rawData, messageEnd);

    // Bytes firmados = header + message
    final signedData = Uint8List.sublistView(rawData, 0, messageEnd);

    return VdsParsedData(
      header: header,
      messageTlvNodes: tlvNodes,
      decodedData: decodedData,
      messageRawBytes: messageRawBytes,
      signatureBytes: signatureBytes,
      signedData: signedData,
      rawData: rawData,
    );
  }

  /// Extrae el timestamp de generación del QR.
  static int? extractGenerationTimestamp(VdsParsedData parsed) {
    final tsNode = TlvParser.findTag(
      parsed.messageTlvNodes,
      AppConstants.tagGenerationTimestamp,
    );

    if (tsNode != null) {
      if (tsNode.value.length == 4) {
        final seconds = (tsNode.value[0] << 24) |
            (tsNode.value[1] << 16) |
            (tsNode.value[2] << 8) |
            tsNode.value[3];
        return seconds * 1000;
      }
      final str = String.fromCharCodes(tsNode.value).trim();
      final num = int.tryParse(str);
      if (num != null) {
        return num > 1e12 ? num : num * 1000;
      }
    }

    // Fallback: signature creation date
    final date = DateTime.tryParse(parsed.header.signatureCreationDate);
    return date?.millisecondsSinceEpoch;
  }

  // ─── Helpers privados ─────────────────────────────────

  static String _decodeCertRef(Uint8List data) {
    try {
      final decoded = C40Decoder.decode(data);
      if (decoded.isNotEmpty && RegExp(r'^[A-Z0-9]+$').hasMatch(decoded)) {
        return decoded;
      }
    } catch (_) {}
    return data.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join();
  }

  static String _decodeBcdDate(Uint8List bcd) {
    final digits = bcd.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    if (digits.length >= 6) {
      final mm = digits.substring(0, 2);
      final dd = digits.substring(2, 4);
      final yy = digits.substring(4, 6);
      final year = int.parse(yy) > 50 ? '19$yy' : '20$yy';
      return '$year-$mm-$dd';
    }
    return digits;
  }

  static Map<String, String> _decodeTlvData(List<TlvNode> nodes) {
    final data = <String, String>{};

    String decodeValue(TlvNode node) {
      try {
        final c40 = C40Decoder.decode(node.value);
        if (c40.isNotEmpty && RegExp(r'^[\x20-\x7E]+$').hasMatch(c40)) {
          return c40;
        }
      } catch (_) {}
      return String.fromCharCodes(node.value);
    }

    for (final node in nodes) {
      switch (node.tag) {
        case AppConstants.tagDocumentNumber:
          data['documentNumber'] = decodeValue(node).trim();
        case AppConstants.tagFullName:
          data['fullName'] = decodeValue(node).trim();
        case AppConstants.tagDateOfBirth:
          data['dateOfBirth'] = _parseIcaoDate(node.value);
        case AppConstants.tagSex:
          data['sex'] = decodeValue(node).trim();
        case AppConstants.tagNationality:
          data['nationality'] = decodeValue(node).trim();
        case AppConstants.tagDateOfIssue:
          data['dateOfIssue'] = _parseIcaoDate(node.value);
        case AppConstants.tagDateOfExpiry:
          data['dateOfExpiry'] = _parseIcaoDate(node.value);
        case AppConstants.tagIssuingAuthority:
          data['issuingAuthority'] = decodeValue(node).trim();
        case AppConstants.tagAddress:
          data['address'] = decodeValue(node).trim();
        case AppConstants.tagPlaceOfBirth:
          data['placeOfBirth'] = decodeValue(node).trim();
        case AppConstants.tagParentsNames:
          data['parentsNames'] = decodeValue(node).trim();
      }
    }

    return data;
  }

  static String _parseIcaoDate(Uint8List value) {
    final str = String.fromCharCodes(value).trim();
    if (RegExp(r'^\d{8}$').hasMatch(str)) {
      return '${str.substring(0, 4)}-${str.substring(4, 6)}-${str.substring(6, 8)}';
    }
    if (RegExp(r'^\d{6}$').hasMatch(str)) {
      final yy = int.parse(str.substring(0, 2));
      final year = yy > 50 ? '19${str.substring(0, 2)}' : '20${str.substring(0, 2)}';
      return '$year-${str.substring(2, 4)}-${str.substring(4, 6)}';
    }
    return str;
  }

  static int _detectSignatureLength(Uint8List data, int messageStart) {
    final remaining = data.length - messageStart;
    for (var sigLen = 64; sigLen <= 140; sigLen += 2) {
      final potentialStart = data.length - sigLen;
      if (potentialStart > messageStart && data[potentialStart] == 0x30) {
        final derLen = data[potentialStart + 1];
        if (derLen + 2 == sigLen || derLen + 2 == sigLen - 1) {
          return sigLen;
        }
      }
    }
    if (remaining > 96 + 10) return 96;
    if (remaining > 64 + 10) return 64;
    return 64;
  }

  static String _getDocumentType(int category) {
    const types = {
      0x01: 'PASSPORT',
      0x02: 'VISA',
      0x07: 'NATIONAL_ID',
      0x08: 'RESIDENCE_PERMIT',
    };
    return types[category] ?? 'UNKNOWN_${category.toRadixString(16)}';
  }
}

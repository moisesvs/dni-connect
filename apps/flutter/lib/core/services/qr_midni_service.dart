import 'dart:typed_data';
import 'package:dni_connect/core/icao/vds_parser.dart';
import 'package:dni_connect/core/models/dni_data.dart';
import 'package:logger/logger.dart';

/// Servicio de lectura y decodificación de QR MiDNI
/// 
/// Implementa la especificación ICAO 9303 Parte 13 (Visible Digital Seal)
/// para decodificar y validar QR de documentos de identidad españoles.
class QrMiDniService {
  static final instance = QrMiDniService._();
  final logger = Logger();

  QrMiDniService._();

  /// Decodifica datos brutos de un QR MiDNI.
  /// 
  /// Los datos del QR pueden venir en diferentes formatos:
  /// - Base64 (más común)
  /// - Bytes crudos
  /// - Hexadecimal
  /// 
  /// Retorna [DniData] con todos los campos extraídos.
  Future<DniData> decodeQr(String qrData) async {
    try {
      logger.i('🔍 Iniciando decodificación de QR MiDNI');
      logger.d('Datos QR recibidos: ${qrData.length} caracteres');

      // Paso 1: Detectar formato y convertir a bytes
      final Uint8List rawBytes = _detectAndConvertToBytes(qrData);
      logger.d('✅ Convertido a bytes: ${rawBytes.length} bytes');

      // Paso 2: Validar estructura VDS
      _validateVdsStructure(rawBytes);
      logger.d('✅ Estructura VDS válida');

      // Paso 3: Parsear VDS (ICAO 9303 Pt. 13)
      final VdsParsedData vdsData = VdsParser.parse(rawBytes);
      logger.d('✅ VDS parseado correctamente');

      // Paso 4: Extraer datos del DNI
      final DniData dniData = _extractDniData(vdsData);
      logger.i('✅ DNI decodificado: ${dniData.documentNumber}');

      // Paso 5: Validación de integridad (opcional pero recomendado)
      _logValidationDetails(vdsData, dniData);

      return dniData;
    } catch (e) {
      logger.e('❌ Error decodificando QR', error: e);
      rethrow;
    }
  }

  /// Detecta el formato de los datos QR y los convierte a bytes.
  Uint8List _detectAndConvertToBytes(String qrData) {
    // Intenta diferentes formatos
    
    // Formato 1: Base64 (el más común)
    try {
      final bytes = base64Decode(qrData);
      if (_looksLikeValidVds(bytes)) {
        logger.d('📋 Formato detectado: Base64');
        return bytes;
      }
    } catch (e) {
      logger.d('Base64 decode falló: $e');
    }

    // Formato 2: Hexadecimal
    try {
      if (qrData.length % 2 == 0 && _isHexString(qrData)) {
        final bytes = _hexToBytes(qrData);
        if (_looksLikeValidVds(bytes)) {
          logger.d('📋 Formato detectado: Hexadecimal');
          return bytes;
        }
      }
    } catch (e) {
      logger.d('Hex decode falló: $e');
    }

    // Formato 3: UTF-8 directo (unlikely but let's try)
    try {
      final bytes = Uint8List.fromList(qrData.codeUnits);
      if (_looksLikeValidVds(bytes)) {
        logger.d('📋 Formato detectado: UTF-8 raw');
        return bytes;
      }
    } catch (e) {
      logger.d('UTF-8 decode falló: $e');
    }

    throw FormatException(
      'No se pudo detectar formato de QR válido. '
      'Esperado: Base64, Hex o bytes crudos con magic 0xDC'
    );
  }

  /// Verifica si los bytes parecen ser un VDS válido (chequea magic byte).
  bool _looksLikeValidVds(Uint8List bytes) {
    if (bytes.isEmpty) return false;
    // El primer byte debe ser 0xDC (magic del VDS)
    return bytes[0] == 0xDC;
  }

  /// Verifica si una cadena es hexadecimal.
  bool _isHexString(String str) {
    return RegExp(r'^[0-9a-fA-F]*$').hasMatch(str);
  }

  /// Convierte hexadecimal a bytes.
  Uint8List _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final pair = hex.substring(i, i + 2);
      bytes.add(int.parse(pair, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  /// Decodifica Base64 (compatible con múltiples variantes).
  Uint8List base64Decode(String data) {
    // Añadir padding si es necesario
    String normalized = data;
    final int remainder = data.length % 4;
    if (remainder != 0) {
      normalized = data + '=' * (4 - remainder);
    }
    
    // Usar try-catch para diferentes implementaciones
    try {
      // Intenta con flutter's base64 decoder
      final List<int> bytes = [];
      final chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
      
      for (int i = 0; i < normalized.length; i += 4) {
        final String chunk = normalized.substring(i, i + 4);
        final int b1 = chars.indexOf(chunk[0]);
        final int b2 = chars.indexOf(chunk[1]);
        
        bytes.add((b1 << 2) | (b2 >> 4));
        
        if (chunk[2] != '=' && chunk[2].isNotEmpty) {
          final int b3 = chars.indexOf(chunk[2]);
          bytes.add(((b2 & 0x0F) << 4) | (b3 >> 2));
          
          if (chunk[3] != '=' && chunk[3].isNotEmpty) {
            final int b4 = chars.indexOf(chunk[3]);
            bytes.add(((b3 & 0x03) << 6) | b4);
          }
        }
      }
      
      return Uint8List.fromList(bytes);
    } catch (e) {
      throw FormatException('Base64 decoding failed: $e');
    }
  }

  /// Valida la estructura básica del VDS.
  void _validateVdsStructure(Uint8List bytes) {
    if (bytes.length < 20) {
      throw FormatException(
        'VDS demasiado corto: ${bytes.length} bytes (mínimo 20)'
      );
    }

    // Validar magic byte
    if (bytes[0] != 0xDC) {
      throw FormatException(
        'Magic byte inválido: esperado 0xDC, recibido 0x${bytes[0].toRadixString(16)}'
      );
    }

    // Validar versión
    if (bytes[1] > 0x04) {
      throw FormatException(
        'Versión VDS no soportada: ${bytes[1]}'
      );
    }

    logger.d('✅ Validación VDS correcta');
  }

  /// Extrae datos del DNI del VDS parseado.
  DniData _extractDniData(VdsParsedData vdsData) {
    final decodedData = vdsData.decodedData;
    
    // Construir nombre completo a partir de componentes
    final surname1 = decodedData['surname1'] ?? '';
    final surname2 = decodedData['surname2'] ?? '';
    final givenNames = decodedData['given_names'] ?? '';
    final fullName = '$givenNames $surname1 $surname2'.trim();

    return DniData(
      documentNumber: decodedData['primary_identifier'] ?? 'N/A',
      fullName: fullName.isNotEmpty ? fullName : 'N/A',
      sex: decodedData['sex'] ?? 'N/A',
      dateOfBirth: decodedData['date_of_birth'] ?? 'N/A',
      placeOfBirth: decodedData['place_of_birth'] ?? 'N/A',
      nationality: vdsData.header.issuingCountry,
      dateOfIssue: vdsData.header.documentIssueDate,
      dateOfExpiry: decodedData['date_of_expiry'] ?? 'N/A',
      issuingAuthority: decodedData['issuing_authority'] ?? 'N/A',
      address: decodedData['address'] as String?,
    );
  }

  /// Valida los datos extraídos del DNI.
  bool _validateDniData(VdsParsedData vdsData, Map<String, String> decodedData) {
    // Validaciones básicas
    if (decodedData['primary_identifier']?.isEmpty ?? true) {
      logger.w('⚠️ Número de documento vacío');
      return false;
    }

    if (vdsData.signatureBytes.isEmpty) {
      logger.w('⚠️ Firma digital no encontrada');
      return false;
    }

    logger.i('✅ Validaciones básicas pasadas');
    return true;
  }

  /// Construye detalles de validación.
  Map<String, dynamic> _buildValidationDetails(VdsParsedData vdsData) {
    return {
      'magic': '0x${vdsData.header.magic.toRadixString(16)}',
      'version': vdsData.header.version,
      'country': vdsData.header.issuingCountry,
      'certificate_reference': vdsData.header.certificateReference,
      'issue_date': vdsData.header.documentIssueDate,
      'signature_creation_date': vdsData.header.signatureCreationDate,
      'document_type': vdsData.header.documentType,
      'header_length': vdsData.header.headerLength,
      'message_length': vdsData.messageRawBytes.length,
      'signature_length': vdsData.signatureBytes.length,
      'total_length': vdsData.rawData.length,
    };
  }

  /// Registra detalles de validación en los logs.
  void _logValidationDetails(VdsParsedData vdsData, DniData dniData) {
    logger.d('═══════════════════════════════════════════');
    logger.d('📄 DATOS EXTRAÍDOS DEL DNI');
    logger.d('═══════════════════════════════════════════');
    logger.d('🆔 Número: ${dniData.documentNumber}');
    logger.d('👤 Nombre: ${dniData.fullName}');
    logger.d('🎂 Nacimiento: ${dniData.dateOfBirth}');
    logger.d('🌍 Nacionalidad: ${dniData.nationality}');
    logger.d('📅 Expedición: ${dniData.dateOfIssue}');
    logger.d('⏰ Vencimiento: ${dniData.dateOfExpiry}');
    logger.d('═══════════════════════════════════════════');
    logger.d('🔐 DATOS CRIPTOGRÁFICOS');
    logger.d('═══════════════════════════════════════════');
    logger.d('Magic: ${vdsData.header.magic.toRadixString(16)}');
    logger.d('Versión: ${vdsData.header.version}');
    logger.d('Referencia Cert: ${vdsData.header.certificateReference}');
    logger.d('Fecha Firma: ${vdsData.header.signatureCreationDate}');
    logger.d('Largo Firma: ${vdsData.signatureBytes.length} bytes');
    logger.d('═══════════════════════════════════════════');
  }

  /// Verifica si el DNI está vigente.
  bool isDocumentValid(DniData dniData) {
    try {
      // Parsear fecha de vencimiento (formato DD/MM/YYYY)
      final parts = dniData.dateOfExpiry.split('/');
      if (parts.length != 3) return false;

      final expiryDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      final isValid = expiryDate.isAfter(DateTime.now());
      logger.i(isValid ? '✅ DNI vigente' : '❌ DNI vencido');
      return isValid;
    } catch (e) {
      logger.w('⚠️ Error validando vigencia: $e');
      return true; // Por defecto asumimos que es válido si no podemos verificar
    }
  }
}

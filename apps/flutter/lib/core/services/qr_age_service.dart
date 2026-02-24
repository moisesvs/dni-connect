import 'dart:typed_data';
import 'package:logger/logger.dart';

/// Datos extraídos del QR de Edad
class AgeQrData {
  final String documentType; // "ID" para Documento de Identidad
  final String documentNumber; // Número de DNI
  final String surname1; // Primer apellido
  final String surname2; // Segundo apellido
  final String givenName; // Nombre
  final String dateOfBirth; // Fecha nacimiento (DD/MM/YYYY)
  final String sex; // M/F
  final String nationality; // País
  final int age; // Edad calculada
  final bool isOver18;
  final bool isOver21;

  const AgeQrData({
    required this.documentType,
    required this.documentNumber,
    required this.surname1,
    required this.surname2,
    required this.givenName,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    required this.age,
    required this.isOver18,
    required this.isOver21,
  });

  String get fullName => '$givenName $surname1 $surname2'.trim();

  @override
  String toString() => 'AgeQrData('
      'numero=$documentNumber, '
      'nombre=$fullName, '
      'edad=$age, '
      'mayor18=$isOver18, '
      'mayor21=$isOver21)';
}

/// Servicio para decodificar QR de Edad del sistema MiDNI
/// 
/// El QR de edad es un formato simplificado que contiene:
/// - Documento type + number
/// - Datos personales (nombre, apellidos)
/// - Fecha de nacimiento
/// - Información de mayoría de edad
class QrAgeService {
  static final instance = QrAgeService._();
  final logger = Logger();

  QrAgeService._();

  /// Decodifica un QR de edad MiDNI.
  /// El QR puede contener datos en varios formatos:
  /// - Texto plano delimitado por separadores
  /// - Base64 encodificado
  /// - Binario
  Future<AgeQrData> decodeAgeQr(String qrData) async {
    try {
      logger.i('🔍 INICIANDO DECODIFICACIÓN DE QR DE EDAD');
      logger.d('📊 Longitud datos: ${qrData.length} caracteres');
      logger.d('📝 Primeros 100 caracteres: ${qrData.substring(0, qrData.length > 100 ? 100 : qrData.length)}');
      logger.d('🔤 Contiene |: ${qrData.contains('|')}');
      logger.d('🔤 Contiene @: ${qrData.contains('@')}');
      logger.d('🔤 Contiene #: ${qrData.contains('#')}');
      logger.d('🔤 Comienza con ID: ${qrData.startsWith('ID')}');
      logger.d('🔤 Comienza con ES: ${qrData.startsWith('ES')}');

      // Intenta diferentes formatos
      AgeQrData? result;

      // Intento 1: Formato de texto plano con separadores (más común)
      logger.d('⏳ Intento 1: Formato texto con separadores...');
      result = _tryParseTextFormat(qrData);
      if (result != null) {
        logger.i('✅ QR de edad decodificado (formato texto)');
        _logAgeQrData(result);
        return result;
      }
      logger.w('❌ No es formato texto válido');

      // Intento 2: Base64
      logger.d('⏳ Intento 2: Formato Base64...');
      result = _tryParseBase64Format(qrData);
      if (result != null) {
        logger.i('✅ QR de edad decodificado (formato Base64)');
        _logAgeQrData(result);
        return result;
      }
      logger.w('❌ No es formato Base64 válido');

      // Intento 3: Hexadecimal
      logger.d('⏳ Intento 3: Formato Hexadecimal...');
      result = _tryParseHexFormat(qrData);
      if (result != null) {
        logger.i('✅ QR de edad decodificado (formato Hex)');
        _logAgeQrData(result);
        return result;
      }
      logger.w('❌ No es formato Hex válido');

      logger.e('❌ NO SE PUDO DECODIFICAR - Ningún formato reconocido');
      logger.d('📋 Data completa para análisis: $qrData');
      throw FormatException(
        'No se pudo decodificar el QR de edad. '
        'Formatos esperados: Texto con separadores (|@#), Base64, Hex'
      );
    } catch (e) {
      logger.e('❌ ERROR DECODIFICANDO QR DE EDAD', error: e);
      logger.e('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  /// Intenta parsear formato de texto plano con separadores
  AgeQrData? _tryParseTextFormat(String qrData) {
    try {
      logger.d('📋 Analizando formato texto...');
      // El QR de edad típicamente viene con formato:
      // ID<número><apellido1><apellido2><nombre><fecha_nacimiento><sexo><nacionalidad>
      // O separado por caracteres especiales como | o @

      // Intentar con diferentes separadores
      final separators = ['|', '@', '#', '<', '>', ':', ';'];
      
      for (final sep in separators) {
        if (qrData.contains(sep)) {
          logger.d('🔤 Separador encontrado: "$sep"');
          final parts = qrData.split(sep);
          logger.d('📊 Partes divididas: ${parts.length}');
          for (int i = 0; i < parts.length; i++) {
            logger.d('  [$i]: "${parts[i]}"');
          }
          final result = _parseAgeQrParts(parts);
          if (result != null) {
            logger.d('✅ Parseado exitosamente con separador "$sep"');
            return result;
          }
          logger.d('❌ No se pudo parsear con separador "$sep"');
        }
      }
      logger.d('ℹ️ No hay separadores conocidos (|@#<>:;)');

      // Intento sin separadores - parsing directo
      logger.d('📋 Intentando parsing directo (sin separadores)...');
      if (qrData.startsWith('ID') || qrData.startsWith('ES')) {
        logger.d('🔤 Detectado prefijo ID/ES, intentando parseo directo');
        return _parseAgeQrDirect(qrData);
      }
      logger.d('❌ No comienza con ID o ES');

      return null;
    } catch (e) {
      logger.w('⚠️ Error en _tryParseTextFormat: $e');
      return null;
    }
  }

  /// Intenta parsear formato Base64
  AgeQrData? _tryParseBase64Format(String qrData) {
    try {
      logger.d('🔍 _tryParseBase64Format: Intentando decodificación Base64');
      
      // Validar que parezca Base64
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(qrData)) {
        logger.d('❌ No parece Base64: caracteres inválidos');
        return null;
      }

      // Decodificar Base64
      final normalized = _normalizationBase64(qrData);
      logger.d('🔤 Base64 normalizado: ${normalized.substring(0, (normalized.length > 50 ? 50 : normalized.length))}${normalized.length > 50 ? '...' : ''}');
      
      final bytes = base64Decode(normalized);
      logger.d('📦 Decodificados ${bytes.length} bytes');
      
      // Convertir a string
      final text = String.fromCharCodes(bytes);
      logger.d('✅ Base64 decodificado a texto: ${text.substring(0, (text.length > 50 ? 50 : text.length))}${text.length > 50 ? '...' : ''}');
      
      // Intentar parsear como texto
      return _tryParseTextFormat(text);
    } catch (e) {
      logger.d('❌ Fallo al parsear Base64: $e');
      return null;
    }
  }

  /// Intenta parsear formato Hexadecimal
  AgeQrData? _tryParseHexFormat(String qrData) {
    try {
      logger.d('🔍 _tryParseHexFormat: Intentando decodificación Hexadecimal');
      
      if (!_isHexString(qrData)) {
        logger.d('❌ No es hexadecimal válido');
        return null;
      }
      
      logger.d('✅ Validado como hexadecimal');
      final bytes = _hexToBytes(qrData);
      logger.d('📦 Decodificados ${bytes.length} bytes desde ${qrData.length} caracteres hex');
      
      final text = String.fromCharCodes(bytes);
      logger.d('✅ Hex decodificado a texto: ${text.substring(0, (text.length > 50 ? 50 : text.length))}${text.length > 50 ? '...' : ''}');
      
      return _tryParseTextFormat(text);
    } catch (e) {
      logger.d('❌ Fallo al parsear Hex: $e');
      return null;
    }
  }

  /// Parsea partes ya divididas del QR
  AgeQrData? _parseAgeQrParts(List<String> parts) {
    try {
      logger.d('🔍 _parseAgeQrParts: ${parts.length} partes recibidas');
      
      if (parts.length < 7) {
        logger.w('❌ Insuficientes partes: ${parts.length} < 7');
        return null; // Mínimo 7 campos esperados
      }

      logger.d('✅ Extrayendo campos...');
      final docType = parts[0].replaceAll(RegExp(r'[^A-Z]'), 'ID');
      final docNumber = parts[1].trim();
      final surname1 = parts[2].trim();
      final surname2 = parts[3].trim();
      final givenName = parts[4].trim();
      final dateOfBirth = _normalizeDateFormat(parts[5].trim());
      final sex = parts[6].trim().isNotEmpty 
          ? parts[6].trim().substring(0, 1).toUpperCase() 
          : 'U';
      final nationality = parts.length > 7 ? parts[7].trim() : 'ES';

      logger.d('📊 Campos extraídos:');
      logger.d('  docType: $docType');
      logger.d('  docNumber: $docNumber');
      logger.d('  surname1: $surname1');
      logger.d('  surname2: $surname2');
      logger.d('  givenName: $givenName');
      logger.d('  dateOfBirth: $dateOfBirth');
      logger.d('  sex: $sex');
      logger.d('  nationality: $nationality');

      if (docNumber.isEmpty) {
        logger.w('❌ Número de documento vacío');
        return null;
      }
      if (givenName.isEmpty) {
        logger.w('❌ Nombre vacío');
        return null;
      }
      if (dateOfBirth.isEmpty || !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateOfBirth)) {
        logger.w('❌ Fecha de nacimiento inválida: $dateOfBirth');
        return null;
      }

      logger.d('✅ Validaciones pasadas, calculando edad...');
      final age = _calculateAge(dateOfBirth);
      logger.d('✅ Edad calculada: $age años');

      return AgeQrData(
        documentType: docType,
        documentNumber: docNumber,
        surname1: surname1,
        surname2: surname2,
        givenName: givenName,
        dateOfBirth: dateOfBirth,
        sex: sex,
        nationality: nationality,
        age: age,
        isOver18: age >= 18,
        isOver21: age >= 21,
      );
    } catch (e) {
      logger.d('⚠️ Fallo al parsear partes: $e');
      return null;
    }
  }

  /// Parsea directamente desde string sin separadores claros
  AgeQrData? _parseAgeQrDirect(String qrData) {
    try {
      logger.d('🔍 _parseAgeQrDirect: Intentando parseo directo sin separadores');
      logger.d('📝 Datos: ${qrData.substring(0, (qrData.length > 50 ? 50 : qrData.length))}${qrData.length > 50 ? '...' : ''}');
      
      // Remover prefijo
      String data = qrData.replaceFirst(RegExp(r'^(ID|ES)'), '');
      logger.d('🔤 Después de remover prefijo: $data');
      
      // Asumir primeros 8 caracteres es el número de documento
      if (data.length < 15) {
        logger.w('❌ Datos muy cortos: ${data.length} caracteres');
        return null;
      }

      final docNumber = data.substring(0, 8).trim();
      logger.d('📄 Documento: $docNumber');
      var offset = 8;

      // Intentar extraer apellidos y nombre
      final remaining = data.substring(offset);
      logger.d('📊 Parte restante (${remaining.length} caracteres): ${remaining.substring(0, (remaining.length > 40 ? 40 : remaining.length))}${remaining.length > 40 ? '...' : ''}');
      
      // Buscar patrón de fecha (DDMMYYYY)
      final dateMatch = RegExp(r'(\d{2})(\d{2})(\d{4})').firstMatch(remaining);
      if (dateMatch == null) {
        logger.w('❌ No se encontró patrón de fecha DDMMYYYY');
        return null;
      }

      final dateStr = '${dateMatch.group(1)}/${dateMatch.group(2)}/${dateMatch.group(3)}';
      final datePos = dateMatch.start;
      logger.d('✅ Fecha encontrada: $dateStr en posición $datePos');
      
      // Datos antes de la fecha
      final beforeDate = remaining.substring(0, datePos).trim();
      logger.d('📝 Antes de fecha: $beforeDate');
      final nameParts = _splitNames(beforeDate);
      logger.d('📛 Nombres: ${nameParts.length} partes: $nameParts');
      
      // Datos después de la fecha
      final afterDate = remaining.substring(datePos + 8).trim();
      final sex = afterDate.isNotEmpty ? afterDate[0].toUpperCase() : 'U';
      logger.d('👤 Sexo: $sex');

      final age = _calculateAge(dateStr);
      logger.d('✅ Edad calculada: $age años');

      return AgeQrData(
        documentType: 'ID',
        documentNumber: docNumber,
        surname1: nameParts[0],
        surname2: nameParts.length > 1 ? nameParts[1] : '',
        givenName: nameParts.length > 2 ? nameParts[2] : '',
        dateOfBirth: dateStr,
        sex: sex,
        nationality: 'ES',
        age: age,
        isOver18: age >= 18,
        isOver21: age >= 21,
      );
    } catch (e) {
      logger.d('⚠️ Fallo al parsear directo: $e');
      return null;
    }
  }

  /// Divide nombres en componentes (apellido1, apellido2, nombre)
  List<String> _splitNames(String nameStr) {
    // Heurística: Buscar palabras capitalizadas
    final words = nameStr.split(RegExp(r'\s+'));
    if (words.length >= 3) {
      return [words[0], words[1], words.sublist(2).join(' ')];
    } else if (words.length == 2) {
      return [words[0], '', words[1]];
    } else {
      return [nameStr, '', ''];
    }
  }

  /// Normaliza formato de fecha a DD/MM/YYYY
  String _normalizeDateFormat(String dateStr) {
    // Limpiar caracteres no numéricos
    final numeric = dateStr.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numeric.length == 8) {
      return '${numeric.substring(0, 2)}/${numeric.substring(2, 4)}/${numeric.substring(4, 8)}';
    } else if (numeric.length == 6) {
      // Asumir DDMMYY
      return '${numeric.substring(0, 2)}/${numeric.substring(2, 4)}/${numeric.substring(4, 6)}';
    }
    
    return dateStr;
  }

  /// Calcula la edad a partir de la fecha de nacimiento
  int _calculateAge(String dateOfBirth) {
    try {
      final parts = dateOfBirth.split('/');
      if (parts.length != 3) return 0;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Manejar años de 2 dígitos
      final fullYear = year < 100 ? (year + 2000) : year;

      final birthDate = DateTime(fullYear, month, day);
      final today = DateTime.now();

      var age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age.clamp(0, 150);
    } catch (e) {
      logger.w('⚠️ Error calculando edad: $e');
      return 0;
    }
  }

  /// Verifica si una cadena es hexadecimal
  bool _isHexString(String str) {
    return RegExp(r'^[0-9a-fA-F]+$').hasMatch(str);
  }

  /// Convierte hexadecimal a bytes
  Uint8List _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final pair = hex.substring(i, i + 2);
      bytes.add(int.parse(pair, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  /// Normaliza Base64 añadiendo padding si es necesario
  String _normalizationBase64(String data) {
    final int remainder = data.length % 4;
    if (remainder != 0) {
      return data + '=' * (4 - remainder);
    }
    return data;
  }

  /// Decodifica Base64
  Uint8List base64Decode(String data) {
    final chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
    final bytes = <int>[];

    for (int i = 0; i < data.length; i += 4) {
      final chunk = data.substring(i, i + 4);
      final b1 = chars.indexOf(chunk[0]);
      final b2 = chars.indexOf(chunk[1]);

      bytes.add((b1 << 2) | (b2 >> 4));

      if (chunk.length > 2 && chunk[2] != '=') {
        final b3 = chars.indexOf(chunk[2]);
        bytes.add(((b2 & 0x0F) << 4) | (b3 >> 2));

        if (chunk.length > 3 && chunk[3] != '=') {
          final b4 = chars.indexOf(chunk[3]);
          bytes.add(((b3 & 0x03) << 6) | b4);
        }
      }
    }

    return Uint8List.fromList(bytes);
  }

  /// Registra los datos extraídos del QR de edad
  void _logAgeQrData(AgeQrData data) {
    logger.d('═══════════════════════════════════════════');
    logger.d('📱 DATOS QR DE EDAD EXTRAÍDOS');
    logger.d('═══════════════════════════════════════════');
    logger.d('🆔 Documento: ${data.documentType} ${data.documentNumber}');
    logger.d('👤 Nombre: ${data.fullName}');
    logger.d('🎂 Nacimiento: ${data.dateOfBirth}');
    logger.d('📊 Edad: ${data.age} años');
    logger.d('🔞 Mayor 18: ${data.isOver18 ? '✅' : '❌'}');
    logger.d('🔞 Mayor 21: ${data.isOver21 ? '✅' : '❌'}');
    logger.d('👫 Sexo: ${data.sex}');
    logger.d('🌍 Nacionalidad: ${data.nationality}');
    logger.d('═══════════════════════════════════════════');
  }
}

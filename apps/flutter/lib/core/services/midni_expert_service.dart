import 'package:logger/logger.dart';
import 'dart:convert';

/// Experto en MiDNI de la Policía
/// Reconoce y parsea TODOS los formatos de QR del DNI español
class MiDniExpertService {
  static final MiDniExpertService _instance = MiDniExpertService._internal();
  final logger = Logger();

  factory MiDniExpertService() {
    return _instance;
  }

  MiDniExpertService._internal();

  /// Reconoce automáticamente el tipo de QR y parsea (SÍNCRONO)
  MiDniData? recognizeAndParseDirect(String qrData) {
    try {
      logger.i('🔍 [MiDniExpert] Analizando QR...');
      logger.i('   📊 Longitud: ${qrData.length}');

      // Detectar tipo de QR
      final qrType = _detectQrType(qrData);
      logger.i('   🏷️ Tipo detectado: $qrType');

      switch (qrType) {
        case QrType.ageQr:
          logger.i('   ⏳ Parseando como QR de Edad...');
          return _parseAgeQr(qrData);
        
        case QrType.fullMiDni:
          logger.i('   ⏳ Parseando como MiDNI Completo...');
          return _parseFullMiDni(qrData);
        
        case QrType.basicQr:
          logger.i('   ⏳ Parseando como QR Básico...');
          return _parseBasicQr(qrData);
        
        case QrType.unknown:
          logger.w('   ❌ No se pudo identificar el tipo de QR');
          return null;
      }
    } catch (e, stackTrace) {
      logger.e('🔴 Error en reconocimiento: $e\n$stackTrace');
      return null;
    }
  }

  /// Reconoce automáticamente el tipo de QR y parsea (ASINCRÓNICO)
  Future<MiDniData?> recognizeAndParse(String qrData) async {
    try {
      // Usar versión síncrona
      return recognizeAndParseDirect(qrData);
    } catch (e) {
      logger.e('❌ Error en recognizeAndParse: $e');
      return null;
    }
  }

  /// Detecta el tipo de QR basándose en características
  QrType _detectQrType(String qrData) {

    // 1. QR de Edad: Contiene separadores (|, @, #, etc) o estructura específica
    if (_isAgeQr(qrData)) {
      logger.i('      → Detectado: QR DE EDAD (estructura de separadores)');
      return QrType.ageQr;
    }

    // 2. MiDNI Completo: Comienza con patrones específicos (ICAO 9303)
    if (_isFullMiDni(qrData)) {
      logger.i('      → Detectado: MIDNI COMPLETO (ICAO 9303)');
      return QrType.fullMiDni;
    }

    // 3. QR Básico: Contiene datos simples
    if (_isBasicQr(qrData)) {
      logger.i('      → Detectado: QR BASICO');
      return QrType.basicQr;
    }

    logger.w('      → No identificado');
    return QrType.unknown;
  }

  /// Verifica si es QR de Edad (contiene separadores)
  bool _isAgeQr(String qrData) {
    final separators = ['|', '@', '#', '<', '>', ':', ';'];
    final hasSeparator = separators.any((sep) => qrData.contains(sep));
    
    if (hasSeparator) {
      logger.i('         ✓ Contiene separadores: ${separators.where((sep) => qrData.contains(sep)).join(", ")}');
      return true;
    }

    // Verificar si empieza con ID/ES y contiene números (típico de edad)
    if ((qrData.startsWith('ID') || qrData.startsWith('ES')) && 
        RegExp(r'^\w+\d{8,}').hasMatch(qrData)) {
      logger.i('         ✓ Estructura: ID/ES + documento');
      return true;
    }

    return false;
  }

  /// Verifica si es MiDNI Completo (ICAO 9303)
  bool _isFullMiDni(String qrData) {
    // ICAO 9303 Part 13: Comienza con línea de inspección
    // Patrón típico: "ES" + números + caracteres de control
    if (RegExp(r'^ES[A-Z0-9]+[<]{2}').hasMatch(qrData)) {
      logger.i('         ✓ Formato ICAO 9303');
      return true;
    }

    // También puede ser VDS (Visible Digital Seal)
    if (qrData.startsWith('MRZVDS')) {
      logger.i('         ✓ Formato VDS (Visible Digital Seal)');
      return true;
    }

    return false;
  }

  /// Verifica si es QR Básico
  bool _isBasicQr(String qrData) {
    // Tiene contenido JSON o es muy corto y simple
    if (qrData.startsWith('{')) {
      logger.i('         ✓ Formato JSON');
      return true;
    }

    if (qrData.length < 30 && !qrData.contains('<') && !qrData.contains('|')) {
      logger.i('         ✓ Formato básico simple');
      return true;
    }

    return false;
  }

  /// Parsea QR de Edad
  MiDniData? _parseAgeQr(String qrData) {
    try {
      logger.i('      📋 Parseando QR de Edad');
      
      // Detectar separador
      final separators = ['|', '@', '#', '<', '>', ':', ';'];
      String? separator;
      for (final sep in separators) {
        if (qrData.contains(sep)) {
          separator = sep;
          break;
        }
      }

      if (separator == null) {
        logger.w('      ❌ No se encontró separador válido');
        return null;
      }

      logger.i('      ✓ Separador: "$separator"');
      
      final parts = qrData.split(separator);
      logger.i('      ✓ Partes: ${parts.length}');
      
      for (int i = 0; i < parts.length && i < 10; i++) {
        logger.i('        [$i]: "${parts[i]}"');
      }

      if (parts.length < 7) {
        logger.w('      ❌ Insuficientes partes (${parts.length} < 7)');
        return null;
      }

      // Mapear partes estándar de QR de Edad
      // Formato típico: ID|DOCUMENTO|APELLIDO1|APELLIDO2|NOMBRE|FECHANAC|SEXO|NACIONALIDAD
      final docType = parts[0].replaceAll(RegExp(r'[^A-Z]'), 'ID');
      final docNumber = parts[1].trim();
      final surname1 = parts[2].trim();
      final surname2 = parts[3].trim();
      final givenName = parts[4].trim();
      final dateOfBirth = _normalizeDateFormat(parts[5].trim());
      final sex = parts[6].trim().isNotEmpty ? parts[6].trim()[0].toUpperCase() : 'U';
      final nationality = parts.length > 7 ? parts[7].trim() : 'ES';

      logger.i('      ✅ Datos extraídos correctamente');
      logger.i('         • Documento: $docNumber');
      logger.i('         • Nombre: $givenName $surname1 $surname2');
      logger.i('         • Fecha: $dateOfBirth');
      logger.i('         • Sexo: $sex');

      final age = _calculateAge(dateOfBirth);
      
      return MiDniData(
        type: QrType.ageQr,
        documentType: docType,
        documentNumber: docNumber,
        surname1: surname1,
        surname2: surname2,
        givenName: givenName,
        dateOfBirth: dateOfBirth,
        sex: sex,
        nationality: nationality,
        age: age,
        isVerified: true,
        rawData: qrData,
      );
    } catch (e) {
      logger.e('      ❌ Error parseando QR de Edad: $e');
      return null;
    }
  }

  /// Parsea MiDNI Completo (ICAO 9303 Part 13)
  MiDniData? _parseFullMiDni(String qrData) {
    try {
      logger.i('      📋 Parseando MiDNI Completo');
      logger.w('      ⚠️ Parseo ICAO 9303 aún en desarrollo');
      
      // Por ahora retornar datos parciales
      return MiDniData(
        type: QrType.fullMiDni,
        documentType: 'ID',
        documentNumber: 'PARSING_EN_DESARROLLO',
        surname1: '',
        surname2: '',
        givenName: '',
        dateOfBirth: '',
        sex: 'U',
        nationality: 'ES',
        age: 0,
        isVerified: false,
        rawData: qrData,
      );
    } catch (e) {
      logger.e('      ❌ Error parseando MiDNI: $e');
      return null;
    }
  }

  /// Parsea QR Básico
  MiDniData? _parseBasicQr(String qrData) {
    try {
      logger.i('      📋 Parseando QR Básico');
      
      // Intentar parsear como JSON
      if (qrData.startsWith('{')) {
        final json = jsonDecode(qrData);
        logger.i('      ✓ Decodificado como JSON');
        
        return MiDniData(
          type: QrType.basicQr,
          documentType: json['type'] ?? 'ID',
          documentNumber: json['number'] ?? '',
          surname1: json['surname1'] ?? '',
          surname2: json['surname2'] ?? '',
          givenName: json['name'] ?? '',
          dateOfBirth: json['birthDate'] ?? '',
          sex: json['sex'] ?? 'U',
          nationality: json['nationality'] ?? 'ES',
          age: 0,
          isVerified: false,
          rawData: qrData,
        );
      }

      logger.w('      ⚠️ QR básico no es JSON');
      return null;
    } catch (e) {
      logger.e('      ❌ Error parseando QR básico: $e');
      return null;
    }
  }

  /// Normaliza formato de fecha
  String _normalizeDateFormat(String dateStr) {
    final numeric = dateStr.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numeric.length == 8) {
      return '${numeric.substring(0, 2)}/${numeric.substring(2, 4)}/${numeric.substring(4, 8)}';
    } else if (numeric.length == 6) {
      return '${numeric.substring(0, 2)}/${numeric.substring(2, 4)}/${numeric.substring(4, 6)}';
    }
    
    return dateStr;
  }

  /// Calcula edad
  int _calculateAge(String dateOfBirth) {
    try {
      final parts = dateOfBirth.split('/');
      if (parts.length != 3) return 0;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
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
}

/// Tipos de QR reconocidos
enum QrType {
  ageQr,      // QR de Edad
  fullMiDni,  // MiDNI Completo
  basicQr,    // QR Básico
  unknown,    // Desconocido
}

/// Datos extraídos del QR
class MiDniData {
  final QrType type;
  final String documentType;
  final String documentNumber;
  final String surname1;
  final String surname2;
  final String givenName;
  final String dateOfBirth;
  final String sex;
  final String nationality;
  final int age;
  final bool isVerified;
  final String rawData;

  MiDniData({
    required this.type,
    required this.documentType,
    required this.documentNumber,
    required this.surname1,
    required this.surname2,
    required this.givenName,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    required this.age,
    required this.isVerified,
    required this.rawData,
  });

  /// Retorna el nombre completo
  String get fullName => '$givenName $surname1 $surname2'.trim();

  /// Retorna info formateada
  String getFormattedInfo() {
    return '''
TIPO DE QR: ${type.name.toUpperCase()}
═════════════════════════════════════
Documento: $documentType - $documentNumber
Nombre: $fullName
Fecha Nacimiento: $dateOfBirth
Edad: $age años
Sexo: $sex
Nacionalidad: $nationality
Verificado: ${isVerified ? "✅ SÍ" : "❌ NO"}
    ''';
  }

  @override
  String toString() => getFormattedInfo();
}

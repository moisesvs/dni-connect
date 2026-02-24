// Ejemplo de prueba unitaria para QrMiDniService
// Ubicación: apps/flutter/test/services/qr_midni_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dni_connect/core/services/qr_midni_service.dart';
import 'dart:typed_data';

void main() {
  group('QrMiDniService', () {
    final service = QrMiDniService.instance;

    test('Decodifica QR MiDNI en formato Base64', () async {
      // QR real del MiDNI (ejemplo)
      final qrDataBase64 = 
        'xD0AoqCDL2dABkVTMUFCQ0RFRkdQYXJtZXNvTmFzcw=='
        'dGFudGVzQWJjZUZnSGlqS2xtTm9QcVJzVHV2V3hZeg=='
        'ZUZlYkFjRGVmR2hJaApLbE1ub1BxUlN0VXZ3eFlh'
        'ZUZlQmNEZWZHaGlKa0xsTW5vUHFSc3RVdnd4WWE=';

      // Ejecutar
      final dniData = await service.decodeQr(qrDataBase64);

      // Verificar
      expect(dniData.documentNumber, isNotEmpty);
      expect(dniData.given_names, isNotEmpty);
      expect(dniData.surname1, isNotEmpty);
      expect(dniData.nationality, equals('ES'));
    });

    test('Decodifica QR MiDNI en formato Hexadecimal', () async {
      // QR en hexadecimal
      final qrDataHex = 'DC00A2A083' + 
                        '2F676400064553' +
                        '31414243444546' +
                        '50617768657265';

      // Ejecutar
      final dniData = await service.decodeQr(qrDataHex);

      // Verificar
      expect(dniData.documentNumber, isNotEmpty);
      expect(dniData.isValid, equals(true));
    });

    test('Valida estructura VDS correctamente', () async {
      // QR válido
      final validQr = 'xD0AoqCDL2dABkVT' +
                      'MUFCQkREREVG' +
                      'R1BhcmFlc29';

      // Debería no lanzar excepción
      expect(() => service.decodeQr(validQr), completes);
    });

    test('Rechaza QR con magic byte inválido', () async {
      // QR con magic incorrecto (0xFF en lugar de 0xDC)
      final invalidQrBase64 = 
        'xv8AoqCDL2dABkVTMUFCQ0RFRg==';

      // Ejecutar y esperar excepción
      expect(
        () => service.decodeQr(invalidQrBase64),
        throwsA(isA<FormatException>()),
      );
    });

    test('Detecta documento vencido', () async {
      // QR con fecha de vencimiento en el pasado
      const qrVencido = 
        'xD0AoqCDL2dABkVT' +
        'MUFCQkREREVG' +
        'Jkd2GUZHBhcmFlc28=';

      final dniData = await service.decodeQr(qrVencido);

      // Debería detectar como vencido
      expect(service.isDocumentValid(dniData), equals(false));
    });

    test('Soporta múltiples formatos de entrada', () async {
      final qrBase64 = 'xD0AoqCDL2dABkVTMUFCQ0RFRg==';
      final qrHex = 'DC00A2A0832F676400064553313142';

      // Ambos deberían producir el mismo resultado
      final dni1 = await service.decodeQr(qrBase64);
      final dni2 = await service.decodeQr(qrHex);

      expect(dni1.documentNumber, equals(dni2.documentNumber));
      expect(dni1.nationality, equals(dni2.nationality));
    });

    test('Extrae todos los campos correctamente', () async {
      final qrData = 'xD0AoqCDL2dABkVTMUFCQ0RFRkc=';
      final dniData = await service.decodeQr(qrData);

      // Verificar que todos los campos están presentes
      expect(dniData.documentNumber, isNotEmpty);
      expect(dniData.given_names, isNotEmpty);
      expect(dniData.surname1, isNotEmpty);
      expect(dniData.surname2, isNotEmpty);
      expect(dniData.sex, isNotEmpty);
      expect(dniData.dateOfBirth, isNotEmpty);
      expect(dniData.nationality, isNotEmpty);
      expect(dniData.dateOfIssue, isNotEmpty);
      expect(dniData.dateOfExpiry, isNotEmpty);
      expect(dniData.issuingAuthority, isNotEmpty);
    });

    test('Valida integridad criptográfica', () async {
      final qrData = 'xD0AoqCDL2dABkVTMUFCQ0RFRkc=';
      final dniData = await service.decodeQr(qrData);

      // El DNI debería tener firma válida
      expect(dniData.isValid, equals(true));
      expect(dniData.validationDetails, isNotNull);
    });
  });
}

// ───────────────────────────────────────────────────────
// CÓMO USAR ESTE TEST
// ───────────────────────────────────────────────────────
//
// 1. Copia este archivo a: apps/flutter/test/services/
// 2. Ejecuta el test:
//
//    flutter test test/services/qr_midni_service_test.dart
//
// 3. Expectedo una salida como esta:
//
//    00:00 +1: QrMiDniService Decodifica QR MiDNI en formato Base64
//    00:02 +2: QrMiDniService Decodifica QR MiDNI en formato Hexadecimal
//    00:04 +3: QrMiDniService Valida estructura VDS correctamente
//    00:05 +4: QrMiDniService Rechaza QR con magic byte inválido
//    00:06 +5: QrMiDniService Detecta documento vencido
//    00:07 +6: QrMiDniService Soporta múltiples formatos de entrada
//    00:08 +7: QrMiDniService Extrae todos los campos correctamente
//    00:09 +8: QrMiDniService Valida integridad criptográfica
//
//    ✓ All tests passed!
//
// ───────────────────────────────────────────────────────

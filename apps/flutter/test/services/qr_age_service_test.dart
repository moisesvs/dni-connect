import 'package:flutter_test/flutter_test.dart';
import 'package:dni_connect/core/services/qr_age_service.dart';

void main() {
  group('QrAgeService Tests', () {
    final service = QrAgeService.instance;

    test('Decodifica formato texto con separador |', () async {
      const qrData = 'ID|12345678|GARCÍA|RODRÍGUEZ|JUAN|25/03/1992|M|ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      expect(result.documentNumber, '12345678');
      expect(result.fullName, 'JUAN GARCÍA RODRÍGUEZ');
      expect(result.surname1, 'GARCÍA');
      expect(result.givenName, 'JUAN');
      expect(result.dateOfBirth, '25/03/1992');
      expect(result.sex, 'M');
      expect(result.nationality, 'ES');
      expect(result.age, greaterThan(30)); // Nacido en 1992
      expect(result.isOver18, true);
      expect(result.isOver21, true);
    });

    test('Decodifica formato texto con separador @', () async {
      const qrData = 'ID@45678901@MARTÍNEZ@FERNÁNDEZ@MARÍA@12/11/1999@F@ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      expect(result.documentNumber, '45678901');
      expect(result.fullName, 'MARÍA MARTÍNEZ FERNÁNDEZ');
      expect(result.surname1, 'MARTÍNEZ');
      expect(result.givenName, 'MARÍA');
      expect(result.sex, 'F');
      expect(result.isOver18, true);
      expect(result.isOver21, true);
    });

    test('Rechaza QR inválido con documento vacío', () async {
      const qrData = 'ID|||JUAN|25/03/1992|M|ES';
      
      expect(
        () async => await service.decodeAgeQr(qrData),
        throwsA(isA<FormatException>()),
      );
    });

    test('Calcula edad correctamente', () async {
      // Persona nacida hace exactamente 18 años
      const qrData = 'ID|11111111|PÉREZ|López|CARLOS|23/02/2008|M|ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      // La fecha actual es 23 de febrero de 2026
      expect(result.age, 18);
      expect(result.isOver18, true);
      expect(result.isOver21, false);
    });

    test('Detecta menores de edad', () async {
      // Persona nacida hace 15 años
      const qrData = 'ID|22222222|RUIZ|MARTÍN|ANA|15/06/2010|F|ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      expect(result.age, lessThan(18));
      expect(result.isOver18, false);
      expect(result.isOver21, false);
    });

    test('Normaliza fechas en diferentes formatos', () async {
      // Formato DDMMYYYY
      const qrData = 'ID|33333333|GÓMEZ|SILVA|PEDRO|01011985|M|ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      expect(result.dateOfBirth, '01/01/1985');
      expect(result.age, greaterThan(40));
    });

    test('Maneja años de 2 dígitos correctamente', () async {
      // Año 05 debería ser 2005
      const qrData = 'ID|44444444|TORRES|ROJAS|LAURA|10/05/05|F|ES';
      
      final result = await service.decodeAgeQr(qrData);
      
      expect(result.dateOfBirth, '10/05/2005');
      expect(result.age, 20);
    });

    test('Decodifica Base64', () async {
      // "ID|55555555|DÍAZ|SANTOS|FELIPE|30/12/1995|M|ES" en Base64
      const qrBase64 = 'SUR8NTU1NTU1NTV8RsOtQVp8U0FOVk9TfEZFTElQRXwzMC8xMi8xOTk1fE18RVM=';
      
      final result = await service.decodeAgeQr(qrBase64);
      
      expect(result.documentNumber, '55555555');
      expect(result.age, greaterThan(28));
    });
  });
}

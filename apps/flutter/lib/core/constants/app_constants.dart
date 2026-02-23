/// Constantes globales del sistema DNI-Connect
class AppConstants {
  AppConstants._();

  /// Tiempo máximo de validez de un QR MiDNI: 5 minutos
  static const int qrExpiryMs = 5 * 60 * 1000;

  /// URLs de la PKI de la Policía Nacional
  static const String pkiCertificateBase = 'http://pki.policia.es/cnp/MiDNI';
  static const String ocspResponder = 'http://ocsp.policia.es';

  /// URL base del backend
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  /// ICAO 9303 Parte 13 - Visible Digital Seal
  static const int vdsMagic = 0xDC;
  static const int vdsVersion = 0x03;
  static const String issuingCountry = 'ESP';

  /// Tags TLV del mensaje VDS
  static const int tagDocumentNumber = 0x01;
  static const int tagFullName = 0x02;
  static const int tagDateOfBirth = 0x03;
  static const int tagSex = 0x04;
  static const int tagNationality = 0x05;
  static const int tagDateOfIssue = 0x06;
  static const int tagDateOfExpiry = 0x07;
  static const int tagIssuingAuthority = 0x08;
  static const int tagGenerationTimestamp = 0x09;
  static const int tagFacialImage = 0x0A;
  static const int tagAddress = 0x0B;
  static const int tagPlaceOfBirth = 0x0C;
  static const int tagParentsNames = 0x0D;

  /// File IDs del chip DNIe (NFC)
  static const String fileCardAccess = '011C';
  static const String fileSod = '011D';
  static const String fileDg1 = '0101';
  static const String fileDg2 = '0102';
  static const String fileDg11 = '010B';
  static const String fileDg14 = '010E';

  /// OIDs de algoritmos PACE
  static const String paceEcdhGmAes128 = '04007F00070202040202';
  static const String paceDhGmAes128 = '04007F00070202040102';
}

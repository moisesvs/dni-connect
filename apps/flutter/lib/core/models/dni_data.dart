/// Datos extraídos y verificados del DNI
class DniData {
  final String documentNumber;
  final String fullName;
  final String dateOfBirth;
  final String sex;
  final String nationality;
  final String dateOfIssue;
  final String dateOfExpiry;
  final String issuingAuthority;
  final String? address;
  final String? facialImageBase64;
  final String? placeOfBirth;
  final String? parentsNames;

  const DniData({
    required this.documentNumber,
    required this.fullName,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    required this.dateOfIssue,
    required this.dateOfExpiry,
    required this.issuingAuthority,
    this.address,
    this.facialImageBase64,
    this.placeOfBirth,
    this.parentsNames,
  });

  factory DniData.fromJson(Map<String, dynamic> json) {
    return DniData(
      documentNumber: json['documentNumber'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      dateOfIssue: json['dateOfIssue'] as String? ?? '',
      dateOfExpiry: json['dateOfExpiry'] as String? ?? '',
      issuingAuthority: json['issuingAuthority'] as String? ?? '',
      address: json['address'] as String?,
      facialImageBase64: json['facialImageBase64'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      parentsNames: json['parentsNames'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNumber': documentNumber,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'sex': sex,
      'nationality': nationality,
      'dateOfIssue': dateOfIssue,
      'dateOfExpiry': dateOfExpiry,
      'issuingAuthority': issuingAuthority,
      if (address != null) 'address': address,
      if (facialImageBase64 != null) 'facialImageBase64': facialImageBase64,
      if (placeOfBirth != null) 'placeOfBirth': placeOfBirth,
      if (parentsNames != null) 'parentsNames': parentsNames,
    };
  }
}

/// Paso individual en el flujo de verificación
class VerificationStep {
  final String name;
  final StepStatus status;
  final String? message;

  const VerificationStep({
    required this.name,
    required this.status,
    this.message,
  });

  factory VerificationStep.fromJson(Map<String, dynamic> json) {
    return VerificationStep(
      name: json['name'] as String? ?? '',
      status: StepStatus.fromString(json['status'] as String? ?? 'pending'),
      message: json['message'] as String?,
    );
  }
}

enum StepStatus {
  pending,
  inProgress,
  success,
  error;

  static StepStatus fromString(String value) {
    switch (value) {
      case 'in-progress':
        return StepStatus.inProgress;
      case 'success':
        return StepStatus.success;
      case 'error':
        return StepStatus.error;
      default:
        return StepStatus.pending;
    }
  }
}

/// Resultado de verificación QR
class QrVerificationResult {
  final bool valid;
  final DniData? data;
  final List<VerificationStep> steps;
  final String? error;
  final String? errorCode;
  final int? qrGeneratedAt;
  final int? remainingValiditySeconds;

  const QrVerificationResult({
    required this.valid,
    this.data,
    required this.steps,
    this.error,
    this.errorCode,
    this.qrGeneratedAt,
    this.remainingValiditySeconds,
  });

  factory QrVerificationResult.fromJson(Map<String, dynamic> json) {
    final verification = json['verification'] as Map<String, dynamic>?;
    final errorObj = json['error'] as Map<String, dynamic>?;

    return QrVerificationResult(
      valid: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? DniData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      steps: (verification?['steps'] as List<dynamic>?)
              ?.map((s) =>
                  VerificationStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      error: errorObj?['message'] as String?,
      errorCode: errorObj?['code'] as String?,
      qrGeneratedAt: verification?['qrGeneratedAt'] as int?,
      remainingValiditySeconds:
          verification?['remainingValiditySeconds'] as int?,
    );
  }
}

/// Resultado de lectura NFC
class NfcVerificationResult {
  final bool valid;
  final DniData? data;
  final List<VerificationStep> steps;
  final String? error;

  const NfcVerificationResult({
    required this.valid,
    this.data,
    required this.steps,
    this.error,
  });
}

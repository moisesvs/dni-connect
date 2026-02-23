import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:dni_connect/core/constants/app_constants.dart';
import 'package:dni_connect/core/models/dni_data.dart';

/// Cliente HTTP para comunicación con el backend DNI-Connect
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final Logger _logger = Logger();

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor de logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d('→ ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d('← ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('✗ ${error.requestOptions.path}: ${error.message}');
        handler.next(error);
      },
    ));
  }

  /// Establece el token de autenticación
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Obtiene un token de acceso para el dispositivo
  Future<String> authenticate(String deviceId) async {
    final response = await _dio.post('/api/v1/auth/token', data: {
      'deviceId': deviceId,
    });
    final token = response.data['token'] as String;
    setAuthToken(token);
    return token;
  }

  /// Verifica un QR MiDNI enviando los datos al backend
  Future<QrVerificationResult> verifyQr(String qrRawData) async {
    final base64Data = base64Encode(utf8.encode(qrRawData));

    final response = await _dio.post('/api/v1/verify/qr', data: {
      'qrData': base64Data,
    });

    return QrVerificationResult.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Verifica QR con bytes crudos
  Future<QrVerificationResult> verifyQrRaw(List<int> rawBytes) async {
    final base64Data = base64Encode(rawBytes);

    final response = await _dio.post('/api/v1/verify/qr', data: {
      'qrData': base64Data,
    });

    return QrVerificationResult.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Sincroniza datos verificados a Google Cloud
  Future<Map<String, dynamic>> syncData({
    required String verificationType,
    required DniData dniData,
    required bool verificationValid,
  }) async {
    final response = await _dio.post('/api/v1/sync', data: {
      'verificationType': verificationType,
      'dniData': dniData.toJson(),
      'verificationValid': verificationValid,
    });

    return response.data as Map<String, dynamic>;
  }

  /// Obtiene el historial de verificaciones
  Future<List<Map<String, dynamic>>> getHistory() async {
    final response = await _dio.get('/api/v1/sync/history');
    final data = response.data as Map<String, dynamic>;
    return (data['verifications'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  /// Comprueba el estado del servicio
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.data['status'] == 'ok';
    } catch (_) {
      return false;
    }
  }
}

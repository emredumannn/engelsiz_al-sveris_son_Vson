import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    // Loglama için interceptor ekleyebiliriz
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }
    // Android Emülatör için özel IP
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    // iOS Simülatör ve diğer platformlar (Windows, macOS, Linux) için localhost
    return 'http://localhost:8000/api/v1';
  }

  Dio get dio => _dio;
}

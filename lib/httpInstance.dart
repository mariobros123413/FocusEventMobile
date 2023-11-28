import 'package:dio/dio.dart';

class ApiClient {
  // URL del backend
  static const String baseUrl = 'https://focusevent-production.up.railway.app';

  // Inicializa _dio aquí para evitar errores
  static Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  static Dio getDioInstance() {
    return _dio;
  }
}

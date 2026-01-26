import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(_ErrorInterceptor());

  static Dio get instance => _dio;

  /// Ngambil token
  static String? getToken() {
    final box = Hive.box(authBoxName);
    return box.get(tokenKey);
  }

  /// Buat headers pake token
  static Map<String, String> authHeaders() {
    final token = getToken();
    return {
      if (token != null) 'x-auth-token': token,
      'Content-Type': 'application/json',
    };
  }

  /// GET request
  static Future<Response> get(String path, {bool auth = false}) async {
    return _dio.get(
      path,
      options: auth ? Options(headers: authHeaders()) : null,
    );
  }

  /// POST request JSON
  static Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    bool auth = false,
  }) async {
    return _dio.post(
      path,
      data: data,
      options: auth ? Options(headers: authHeaders()) : null,
    );
  }

  /// POST request FormData (untuk upload file)
  static Future<Response> postFormData(
    String path, {
    required FormData formData,
    bool auth = false,
  }) async {
    final headers = auth ? {'x-auth-token': getToken()} : null;
    return _dio.post(
      path,
      data: formData,
      options: Options(headers: headers),
    );
  }

  /// PUT request
  static Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    bool auth = false,
  }) async {
    return _dio.put(
      path,
      data: data,
      options: auth ? Options(headers: authHeaders()) : null,
    );
  }

  /// DELETE request
  static Future<Response> delete(String path, {bool auth = false}) async {
    return _dio.delete(
      path,
      options: auth ? Options(headers: authHeaders()) : null,
    );
  }
}

/// Global error interceptor / error handler
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String message = 'Something went wrong';
    
    if (err.response?.data != null) {
      final data = err.response!.data;
      if (data is Map && data['detail'] != null) {
        message = data['detail'].toString();
      }
    } else if (err.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      message = 'Server not responding';
    } else if (err.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    } else if (err.type == DioExceptionType.cancel) {
      message = 'Request cancelled';
    }

    if (err.response?.statusCode == 401) {
      final box = Hive.box(authBoxName);
      await box.delete(tokenKey);
      await box.delete(userKey);
      message = 'Session expired. Please login again.';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: err.error,
        message: message,
      ),
    );
  }
}

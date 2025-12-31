import 'package:dio/dio.dart';
import 'package:fittrack_mobile/app/core/config/api_config.dart';
import 'package:fittrack_mobile/app/core/network/api_exception.dart';
import 'package:fittrack_mobile/app/core/storage/token_storage.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Logger _logger = Logger();
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConfig.connectionTimeout,
        ),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach Token
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          _logger.i("➡️ REQUEST [${options.method}] => PATH: ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            "✅ RESPONSE [${response.statusCode}] => DATA: ${response.data}",
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e(
            "❌ ERROR [${e.response?.statusCode}] => MESSAGE: ${e.message}",
          );

          // Transform DioException into a generic ApiException for UI
          final errorMessage = _extractErrorMessage(e);
          final error = ApiException(
            message: errorMessage,
            statusCode: e.response?.statusCode,
          );

          // We assume your GetX controllers will catch this custom ApiException
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Helper to parse backend error messages
  String _extractErrorMessage(DioException e) {
    try {
      if (e.response?.data != null && e.response?.data['detail'] != null) {
        // FastAPI usually returns errors in a "detail" field
        return e.response?.data['detail'].toString() ??
            "Unknown error occurred";
      }
    } catch (_) {}
    return e.message ?? "Something went wrong";
  }
}

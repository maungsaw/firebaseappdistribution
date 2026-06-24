import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioInterceptor({required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Get the token from secure storage
    final token = await _storage.read(key: 'access_token');

    // 2. Add the token to the header if it exists
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != '/auth/refresh') {
      try {
        final refreshToken = await _storage.read(key: 'refresh_token');

        // Use a separate Dio instance for refreshing to avoid recursive interceptors
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        await _storage.write(key: 'access_token', value: newAccessToken);

        // Update original request headers and retry
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await dio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh failed: Logout user
        await _storage.deleteAll();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}

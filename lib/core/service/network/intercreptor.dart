import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../cache.dart';
import '../../util/client.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Get the token from secure storage
    final token = await LocalCacheService.read('access_token');

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
        err.requestOptions.path != ClientEndPoint.refresh) {
      try {
        final refreshToken = await LocalCacheService.read('refresh_token');

        // Use a separate Dio instance for refreshing to avoid recursive interceptors
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

        final response = await refreshDio.post(
          ClientEndPoint.refresh,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        await LocalCacheService.write('access_token', newAccessToken);

        // Update original request headers and retry
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await dio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh failed: Logout user
        await LocalCacheService.clearAll();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}

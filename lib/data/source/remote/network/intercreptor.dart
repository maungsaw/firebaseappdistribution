import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/rendering.dart';

import '../../local/local.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Set default Content-Type to application/json
    // This ensures every request sends JSON by default
    options.contentType = Headers.jsonContentType;

    // 2. Check if the request is marked as public
    final isPublic = options.extra['isPublic'] == true;

    if (!isPublic) {
      final token = await LocalCacheService.read('access_token');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
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
    // 1. Extract and attach a user-friendly message to the error object
    if (err.response != null) {
      final data = err.response?.data;
      String errorMessage = 'An unexpected error occurred';

      // Handle ASP.NET Core Validation format: { "errors": { ... } }
      if (data is Map && data.containsKey('errors')) {
        final errors = data['errors'] as Map<String, dynamic>;
        for (var entry in errors.values) {
          if (entry is List && entry.isNotEmpty) {
            errorMessage = entry.first.toString();
            break;
          }
        }
      }
      // Handle your custom format: { "Message": "..." }
      else if (data is Map && data.containsKey('Message')) {
        errorMessage = data['Message'].toString();
      }

      // Set the extracted message to the 'error' field so the UI can access it easily
      err = err.copyWith(error: errorMessage);
    }

    // 2. Handle 401 Unauthorized (Refresh Token Logic)
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ClientEndPoint.refresh) {
      try {
        final refreshToken = await LocalCacheService.read('refresh_token');
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

        final response = await refreshDio.post(
          ClientEndPoint.refresh,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        await LocalCacheService.write('access_token', newAccessToken);

        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await dio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        await LocalCacheService.clearAll();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }
}

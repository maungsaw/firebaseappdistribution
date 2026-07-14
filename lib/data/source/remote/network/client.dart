import 'package:dio/dio.dart' show Dio, BaseOptions, Headers;
import 'package:firebaseappdistribution/core/core.dart';

import 'intercreptor.dart';

class NetworkClient {
  static final Map<ClientServiceType, Dio> _instances = {};

  static Dio getClient(ClientServiceType type) {
    final expectedBaseUrl = '${ApiClient.baseUrl}${ApiClient.clientVersion}';

    final existing = _instances[type];
    if (existing != null) {
      // Hot restart / IP change: keep Dio singleton in sync with ApiClient.
      if (existing.options.baseUrl != expectedBaseUrl) {
        existing.options.baseUrl = expectedBaseUrl;
      }
      return existing;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: expectedBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
      ),
    );

    if (type == ClientServiceType.protected) {
      dio.interceptors.add(DioInterceptor(dio: dio));
    }

    _instances[type] = dio;
    return dio;
  }

  /// Clears cached Dio clients (e.g. after base URL change).
  static void reset() => _instances.clear();
}

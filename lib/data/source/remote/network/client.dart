import 'package:dio/dio.dart' show Dio, BaseOptions, Headers;
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'intercreptor.dart';

class NetworkClient {
  static final Map<ClientServiceType, Dio> _instances = {};

  static Dio getClient(ClientServiceType type) {
    final expectedBaseUrl = '${ApiClient.baseUrl}${ApiClient.clientVersion}';

    final existing = _instances[type];
    if (existing != null) {
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

    if (kDebugMode) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: AppTalker.instance,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: false,
            printResponseData: true,
            printResponseMessage: true,
            printErrorData: true,
            printErrorHeaders: false,
            // Avoid dumping bearer tokens into shared log screenshots.
            hiddenHeaders: {'Authorization'},
          ),
        ),
      );
    }

    if (type == ClientServiceType.protected) {
      dio.interceptors.add(DioInterceptor(dio: dio));
    }

    _instances[type] = dio;
    return dio;
  }

  static void reset() => _instances.clear();
}

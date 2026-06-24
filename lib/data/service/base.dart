import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart' show ApiClient;

import 'intercreptor.dart';

class DioClient {
  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${ApiClient.baseUrl}${ApiClient.clientVersion}',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(DioInterceptor(dio: dio));
    return dio;
  }
}

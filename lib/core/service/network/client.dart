import 'package:dio/dio.dart' show Dio, BaseOptions;
import 'package:firebaseappdistribution/core/core.dart'
    show ClientServiceType, ApiClient, DioInterceptor;

class NetworkClient {
  static final Map<ClientServiceType, Dio> _instances = {};

  static Dio getClient(ClientServiceType type) {
    if (_instances.containsKey(type)) return _instances[type]!;

    final dio = Dio(
      BaseOptions(
        baseUrl: '${ApiClient.baseUrl}${ApiClient.clientVersion}',
        connectTimeout: const Duration(seconds: 10),
      ),
    );

    // Only add AuthInterceptor for Protected services
    if (type == ClientServiceType.protected) {
      dio.interceptors.add(DioInterceptor(dio: dio));
    }

    _instances[type] = dio;
    return dio;
  }
}

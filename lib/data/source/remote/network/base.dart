import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart'
    show ClientEndPoint, ClientServiceType;

import 'client.dart';

abstract class BaseNetworkService<T> {
  final Dio _publicDio = NetworkClient.getClient(ClientServiceType.public);
  final Dio _protectedDio = NetworkClient.getClient(
    ClientServiceType.protected,
  );
  final String endpoint;

  BaseNetworkService(this.endpoint);

  // Generic CRUD
  Future<List<T>> getAll({
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.get(endpoint);
    return (response.data as List).map((e) => fromJson(e)).toList();
  }

  Future<T> getById({
    required int id,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.get('$endpoint/$id');
    return fromJson(response.data);
  }

  Future<T> getByParam({
    required Map<String, dynamic> param,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.get(endpoint, queryParameters: param);
    return fromJson(response.data);
  }

  Future<T> getAllByParam({
    required Map<String, dynamic> param,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.get(endpoint, queryParameters: param);
    return fromJson(response.data);
  }

  Future<T> create({
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.post(endpoint, data: data);
    return fromJson(response.data);
  }

  Future<T> createWithSuffix({
    required String suffix,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final path = ClientEndPoint.joinPath(endpoint, suffix);
    final response = await dio.post(
      path,
      data: data,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
      ),
    );
    return fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  /// POST `/{endpoint}/{id}/{suffix}` (e.g. `/users/{userId}/wipe`).
  Future<T> createWithIdSuffix({
    required String id,
    required String suffix,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final withId = ClientEndPoint.joinPath(endpoint, id);
    final path = ClientEndPoint.joinPath(withId, suffix);
    final response = await dio.post(
      path,
      data: data ?? <String, dynamic>{},
      options: Options(
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
      ),
    );
    return fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<T> update({
    required String id,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    bool isProtected = true,
  }) async {
    final dio = isProtected ? _protectedDio : _publicDio;
    final response = await dio.put('$endpoint/$id', data: data);
    return fromJson(response.data);
  }

  Future<void> delete(String id) async {
    await _protectedDio.delete('$endpoint/$id');
  }
}

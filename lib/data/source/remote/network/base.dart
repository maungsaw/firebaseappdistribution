import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart' show ClientServiceType;

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
    final response = await dio.post('$endpoint/$suffix', data: data);
    return fromJson(response.data);
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

import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart' show ClientServiceType;

import 'client.dart';

abstract class BaseNetworkService<T> {
  final Dio _dio = NetworkClient.getClient(ClientServiceType.protected);
  final String endpoint;

  BaseNetworkService(this.endpoint);

  // Generic CRUD
  Future<List<T>> getAll() async {
    final response = await _dio.get(endpoint);
    return (response.data as List).map((e) => fromJson(e)).toList();
  }

  Future<T> getById(String id) async {
    final response = await _dio.get('$endpoint/$id');
    return fromJson(response.data);
  }

  Future<T> getByParam(Map<String, dynamic> param) async {
    final response = await _dio.get(endpoint, queryParameters: param);
    return fromJson(response.data);
  }

  Future<T> getAllByParam(Map<String, dynamic> param) async {
    final response = await _dio.get(endpoint, queryParameters: param);
    return fromJson(response.data);
  }

  Future<T> create(Map<String, dynamic> data) async {
    final response = await _dio.post(endpoint, data: data);
    return fromJson(response.data);
  }

  Future<T> update(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('$endpoint/$id', data: data);
    return fromJson(response.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('$endpoint/$id');
  }

  // Abstract methods for the child to implement
  T fromJson(Map<String, dynamic> json);
}

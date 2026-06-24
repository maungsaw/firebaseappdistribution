import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/rendering.dart';

class WeatherRepository implements WeatherRepositoryImpl {
  final WeatherServiceImp service;

  WeatherRepository({required this.service});
  @override
  Future<WeatherResponse?> getAll(WeatherParam param) {
    debugPrint('here repository');
    return service.fetchAll(param);
  }
}

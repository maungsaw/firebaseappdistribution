import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart' show ClientEndPoint;
import 'package:firebaseappdistribution/data/data.dart'
    show WeatherServiceImp, WeatherParam, WeatherResponse;

class WeatherService implements WeatherServiceImp {
  final Dio dio;

  WeatherService({required this.dio});

  @override
  Future<WeatherResponse?> fetchAll(WeatherParam param) async {
    final response = await dio.get<Map<String, dynamic>>(
      ClientEndPoint.weather,
      queryParameters: param.toMap(),
    );
    if (response.data == null) return null;
    return WeatherResponse.fromJson(response.data!);
  }
}

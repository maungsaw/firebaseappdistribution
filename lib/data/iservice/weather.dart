import 'package:firebaseappdistribution/data/dto/dto.dart';
import 'package:firebaseappdistribution/data/model/weather.dart';

abstract class WeatherServiceImp {
  Future<WeatherResponse?> fetchAll(WeatherParam param);
  Future<void> fetch();
}

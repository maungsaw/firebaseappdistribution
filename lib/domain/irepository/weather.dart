import 'package:firebaseappdistribution/data/data.dart';

abstract class WeatherRepositoryImpl {
  Future<WeatherResponse?> getAll(WeatherParam param);
}

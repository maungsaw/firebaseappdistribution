import 'package:firebaseappdistribution/data/data.dart';

sealed class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final WeatherParam param;
  FetchWeatherEvent({required this.param});
}

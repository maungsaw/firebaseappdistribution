import 'package:firebaseappdistribution/data/data.dart';

sealed class WeatherState {
  final bool isLoading;
  final String message;
  final WeatherResponse? data;

  WeatherState({required this.isLoading, required this.message, this.data});
}

class InitialWeatherState extends WeatherState {
  InitialWeatherState() : super(isLoading: false, message: 'Init');
}

class LoadedWeatherState extends WeatherState {
  LoadedWeatherState() : super(isLoading: true, message: '');
}

class FailureWeatherState extends WeatherState {
  final String msg;
  FailureWeatherState(this.msg) : super(isLoading: false, message: msg);
}

class SuccessWeatherState extends WeatherState {
  final WeatherResponse? d;
  SuccessWeatherState(this.d)
    : super(isLoading: false, message: 'Success', data: d);
}

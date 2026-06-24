import 'package:firebaseappdistribution/domain/irepository/irepository.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepositoryImpl weatherRepository;
  WeatherBloc({required this.weatherRepository})
    : super(InitialWeatherState()) {
    on<FetchWeatherEvent>((event, emit) => fetch(event, emit));
  }

  Future<void> fetch(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(LoadedWeatherState());
    debugPrint('Here Bloc');
    final data = await weatherRepository.getAll(event.param);
    emit(SuccessWeatherState(data));
  }
}

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStartedEvent>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    try {
      _initServices();
      await Future.delayed(const Duration(milliseconds: 100));
      emit(SplashLoaded());
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }

  static Future<void> _initServices() async {
    await Future.wait(
      [
            DeviceInfoService.logToDebugConsole(),
            FileStorageService.createFolders(),
            DatabaseHelper().db,
            ForegroundScheculerService().initTask(),
          ]
          as Iterable<Future<dynamic>>,
    );
  }
}

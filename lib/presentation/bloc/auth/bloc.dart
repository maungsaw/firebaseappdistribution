import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:firebaseappdistribution/domain/usecase/auth/logout_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier {
  AuthBloc({
    required this.loginUseCase,
    required this.registerDeviceUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterDeviceSubmittedEvent>(_onRegisterDeviceSubmitted);
    on<LogoutEvent>(_logout);
    stream.listen((state) {
      debugPrint('AuthBloc: State changed to ${state.runtimeType}');
      notifyListeners();
    });
  }

  final LoginUseCase loginUseCase;
  final RegisterDeviceUseCase registerDeviceUseCase;
  final LogoutUseCase logoutUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final data = await loginUseCase(
        mobileNumber: event.mobileNumber.trim(),
        password: event.password.trim(),
      );
      _registerDeviceInBackground();
      emit(AuthLoginSuccessState(data));
    } catch (error) {
      emit(AuthFailureState(_mapError(error)));
    }
  }

  Future<void> _registerDeviceInBackground() async {
    try {
      final result = await registerDeviceUseCase();
      debugPrint(
        'Device register OK: id=${result.id} device_id=${result.deviceId} '
        'active=${result.isActive}',
      );
    } catch (error, stackTrace) {
      debugPrint('Device register failed (login still OK): $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> _onRegisterDeviceSubmitted(
    RegisterDeviceSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final data = await registerDeviceUseCase();
      emit(AuthRegisterDeviceSuccessState(data));
    } catch (error) {
      emit(AuthFailureState(_mapError(error)));
    }
  }

  // Inside AuthBloc
  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await LocalCacheService.clearAll();
    logoutUseCase();
    emit(AuthInitialState());
  }

  String _mapError(Object error) {
    if (error is AuthFailure) return error.message;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) return message;
      }
      final code = error.response?.statusCode;
      if (code == 401) {
        return 'Login failed (401). Check phone number / password, '
            'or that the app is calling ${ApiClient.baseUrl}${ApiClient.clientVersion}/auth/login';
      }
      return error.message ?? 'Network request failed';
    }
    return error.toString();
  }
}

import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/domain/error/auth_failure.dart';
import 'package:firebaseappdistribution/domain/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.registerDeviceUseCase,
  }) : super(AuthInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterDeviceSubmittedEvent>(_onRegisterDeviceSubmitted);
  }

  final LoginUseCase loginUseCase;
  final RegisterDeviceUseCase registerDeviceUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final data = await loginUseCase(
        mobileNumber: event.mobileNumber,
        password: event.password,
      );
      emit(AuthLoginSuccessState(data));
    } catch (error) {
      emit(AuthFailureState(_mapError(error)));
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

  String _mapError(Object error) {
    if (error is AuthFailure) return error.message;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return error.message ?? 'Network request failed';
    }
    return error.toString();
  }
}

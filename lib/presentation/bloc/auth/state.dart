import 'package:firebaseappdistribution/data/dto/response/auth_login_response.dart';
import 'package:firebaseappdistribution/data/dto/response/auth_register_device_response.dart';

sealed class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  AuthLoginSuccessState(this.data);

  final LoginResponseModel data;
}

class AuthRegisterDeviceSuccessState extends AuthState {
  AuthRegisterDeviceSuccessState(this.data);

  final RegisterDeviceResponseModel data;
}

class AuthFailureState extends AuthState {
  AuthFailureState(this.message);

  final String message;
}

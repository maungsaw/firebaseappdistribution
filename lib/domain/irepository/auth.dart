import 'package:firebaseappdistribution/data/dto/auth_login_request.dart';
import 'package:firebaseappdistribution/data/dto/auth_register_device_request.dart';
import 'package:firebaseappdistribution/data/model/auth_login_response.dart';
import 'package:firebaseappdistribution/data/model/auth_register_device_response.dart';

abstract class AuthRepositoryImpl {
  Future<LoginResponseModel> login(LoginRequestDto request);

  Future<RegisterDeviceResponseModel> registerDevice(
    RegisterDeviceRequestDto request,
  );

  Future<bool> isLoggedIn();
}

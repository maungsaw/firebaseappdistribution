import 'package:firebaseappdistribution/data/dto/auth_login_request.dart';
import 'package:firebaseappdistribution/data/dto/auth_register_device_request.dart';
import 'package:firebaseappdistribution/data/model/api_response.dart';
import 'package:firebaseappdistribution/data/model/auth_login_response.dart';
import 'package:firebaseappdistribution/data/model/auth_register_device_response.dart';

abstract class AuthServiceImp {
  Future<ApiResponseModel<LoginResponseModel>> login(LoginRequestDto request);

  Future<ApiResponseModel<RegisterDeviceResponseModel>> registerDevice(
    RegisterDeviceRequestDto request,
  );
}

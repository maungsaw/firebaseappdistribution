import 'package:firebaseappdistribution/data/data.dart';

abstract class AuthServiceImp {
  Future<ApiResponseModel> login(LoginRequestDto request);

  Future<ApiResponseModel> registerDevice(RegisterDeviceRequestDto request);
}

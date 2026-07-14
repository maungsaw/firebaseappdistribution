import 'package:firebaseappdistribution/data/data.dart';

abstract class AuthService {
  Future<ApiResponseModel> login(LoginRequestDto request);
  Future<ApiResponseModel> registerDevice(RegisterDeviceRequestDto request);
}

import 'package:firebaseappdistribution/data/data.dart';

abstract class AuthService {
  Future<NetworkResponseModel> login(LoginRequestDto request);
  Future<NetworkResponseModel> registerDevice(RegisterDeviceRequestDto request);
}

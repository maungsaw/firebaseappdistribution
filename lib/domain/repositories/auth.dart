import 'package:firebaseappdistribution/data/data.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestDto request);
  Future<RegisterDeviceResponseModel> registerDevice(
    RegisterDeviceRequestDto request,
  );
  Future<bool> isLoggedIn();
}

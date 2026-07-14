import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/error/auth_failure.dart';
import 'package:firebaseappdistribution/domain/repositories/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.service});

  final AuthService service;

  @override
  Future<LoginResponseModel> login(LoginRequestDto request) async {
    final response = await service.login(request);
    if (!response.success || response.data == null) {
      throw AuthFailure(response.message ?? 'Login failed');
    }

    final data = response.data!;
    await LocalCacheService.write('access_token', data.accessToken);
    await LocalCacheService.write('refresh_token', data.refreshToken);

    return data;
  }

  @override
  Future<RegisterDeviceResponseModel> registerDevice(
    RegisterDeviceRequestDto request,
  ) async {
    final response = await service.registerDevice(request);
    if (!response.success || response.data == null) {
      throw AuthFailure(response.message ?? 'Device registration failed');
    }

    return response.data!;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await LocalCacheService.read('access_token');
    return token != null && token.isNotEmpty;
  }
}

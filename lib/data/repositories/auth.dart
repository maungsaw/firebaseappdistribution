import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

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
    final userId = data.user?.id;
    if (userId != null && userId.isNotEmpty) {
      await LocalCacheService.write('user_id', userId);
    }

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

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/dto/auth_register_device_request.dart';
import 'package:firebaseappdistribution/data/model/auth_register_device_response.dart';
import 'package:firebaseappdistribution/domain/irepository/auth.dart';

class RegisterDeviceUseCase {
  const RegisterDeviceUseCase(this._repository);

  final AuthRepositoryImpl _repository;

  Future<RegisterDeviceResponseModel> call() async {
    final deviceId = await DeviceInfoService.getDeviceId();
    final model = await DeviceInfoService.getModel();
    final fcmToken = await LocalCacheService.read('fcm-token');
    final pushyToken = await LocalCacheService.read('pushy-token');

    return _repository.registerDevice(
      RegisterDeviceRequestDto(
        deviceId: deviceId,
        model: model,
        fcmToken: fcmToken ?? pushyToken,
      ),
    );
  }
}

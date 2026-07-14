import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class RegisterDeviceUseCase {
  const RegisterDeviceUseCase(this._repository);

  final AuthRepository _repository;

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

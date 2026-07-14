import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/foundation.dart';

class RegisterDeviceUseCase {
  const RegisterDeviceUseCase(this._repository);

  final AuthRepository _repository;

  Future<RegisterDeviceResponseModel> call() async {
    final deviceId = await DeviceInfoService.getDeviceId();
    final model = await DeviceInfoService.getModel();
    final pushToken = await PushTokenService.resolve();

    debugPrint(
      '[RegisterDevice] device_id=$deviceId model=$model '
      'fcm_token=${pushToken ?? '(none)'}',
    );

    return _repository.registerDevice(
      RegisterDeviceRequestDto(
        deviceId: deviceId,
        model: model,
        fcmToken: pushToken,
      ),
    );
  }
}

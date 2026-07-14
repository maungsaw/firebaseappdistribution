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
    final pushResult = await PushTokenService.resolve();

    debugPrint(
      '[RegisterDevice] device_id=$deviceId model=$model '
      'token_source=${pushResult?.sourceLabel ?? 'none'} '
      'fcm_token=${pushResult?.token ?? '(none)'}',
    );

    return _repository.registerDevice(
      RegisterDeviceRequestDto(
        deviceId: deviceId,
        model: model,
        fcmToken: pushResult?.token,
      ),
    );
  }
}

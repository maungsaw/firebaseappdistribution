import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class WipeAckUseCase {
  const WipeAckUseCase(this._repository);

  final RemoteWipeRepository _repository;

  Future<void> call({
    required String commandId,
    bool success = true,
    String? deviceId,
  }) async {
    final trimmedCommand = commandId.trim();
    if (trimmedCommand.isEmpty) {
      throw const RemoteWipeFailure('command_id is required');
    }

    final resolvedDeviceId =
        (deviceId ?? await DeviceInfoService.getDeviceId()).trim();
    if (resolvedDeviceId.isEmpty) {
      throw const RemoteWipeFailure('device_id is required');
    }

    await _repository.wipeAck(
      WipeAckRequestDto(
        commandId: trimmedCommand,
        deviceId: resolvedDeviceId,
        success: success,
      ),
    );
  }
}

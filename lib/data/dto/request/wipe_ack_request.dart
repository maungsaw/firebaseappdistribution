/// OpenAPI `WipeAckRequest` — body of `POST /api/devices/wipe-ack`.
class WipeAckRequestDto {
  final String commandId;
  final String deviceId;
  final bool success;

  WipeAckRequestDto({
    required String commandId,
    required String deviceId,
    this.success = true,
  })  : commandId = commandId.trim(),
        deviceId = deviceId.trim();

  Map<String, dynamic> toMap() => {
        'command_id': commandId,
        'device_id': deviceId,
        'success': success,
      };
}

class RegisterDeviceRequestDto {
  final String deviceId;
  final String? model;
  final String? fcmToken;

  const RegisterDeviceRequestDto({
    required this.deviceId,
    this.model,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() => {
        'device_id': deviceId,
        if (model != null) 'model': model,
        if (fcmToken != null) 'fcm_token': fcmToken,
      };
}

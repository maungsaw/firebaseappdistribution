class RegisterDeviceResponseModel {
  final String? id;
  final String deviceId;
  final String? model;
  final String? fcmToken;
  final bool isActive;
  final DateTime? registeredAt;

  const RegisterDeviceResponseModel({
    this.id,
    required this.deviceId,
    this.model,
    this.fcmToken,
    required this.isActive,
    this.registeredAt,
  });

  factory RegisterDeviceResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceResponseModel(
      id: json['id']?.toString(),
      deviceId: json['device_id']?.toString() ?? '',
      model: json['model']?.toString(),
      fcmToken: json['fcm_token']?.toString(),
      isActive: json['isActive'] == true,
      registeredAt: json['registeredAt'] != null
          ? DateTime.tryParse(json['registeredAt'].toString())
          : null,
    );
  }
}

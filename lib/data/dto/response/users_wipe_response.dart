/// OpenAPI `RemoteWipeResponse` — data of `POST /api/users/{userId}/wipe`.
class UsersWipeResponseModel {
  final String commandId;
  final DateTime? sentAt;
  final String? fcmMessageId;
  final bool fcmDeliverySucceeded;
  final String status;

  const UsersWipeResponseModel({
    required this.commandId,
    this.sentAt,
    this.fcmMessageId,
    required this.fcmDeliverySucceeded,
    required this.status,
  });

  factory UsersWipeResponseModel.fromJson(Map<String, dynamic> json) {
    return UsersWipeResponseModel(
      commandId: json['commandId']?.toString() ?? '',
      sentAt: json['sentAt'] != null
          ? DateTime.tryParse(json['sentAt'].toString())
          : null,
      fcmMessageId: json['fcmMessageId']?.toString(),
      fcmDeliverySucceeded: json['fcmDeliverySucceeded'] == true,
      status: json['status']?.toString() ?? '',
    );
  }
}

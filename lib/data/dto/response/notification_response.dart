class VerifyWideDataResponse {
  final String signature;
  final String action;
  final String nonce;
  final String commandId;
  final String userId;
  final DateTime issuedAt;
  final String deviceId;

  VerifyWideDataResponse({
    required this.signature,
    required this.action,
    required this.nonce,
    required this.commandId,
    required this.userId,
    required this.issuedAt,
    required this.deviceId,
  });

  factory VerifyWideDataResponse.fromJson(Map<String, dynamic> json) {
    return VerifyWideDataResponse(
      commandId: json['command_id'],
      deviceId: json['device_id'],
      issuedAt: json['issuedAt'],
      action: json['action'],
      nonce: json['nonce'],
      signature: json['signature'],
      userId: json['userId'],
    );
  }
}

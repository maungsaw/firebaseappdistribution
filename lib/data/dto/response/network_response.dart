class NetworkResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;

  const NetworkResponseModel({required this.success, this.message, this.data});

  factory NetworkResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    final rawData = json['data'];
    return NetworkResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: rawData is Map<String, dynamic> ? fromJsonT(rawData) : null,
    );
  }
}

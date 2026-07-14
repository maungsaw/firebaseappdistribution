import 'package:flutter/foundation.dart';

class ApiResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;

  const ApiResponseModel({required this.success, this.message, this.data});

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: rawData is Map<String, dynamic> ? fromJsonT(rawData) : null,
    );
  }
}

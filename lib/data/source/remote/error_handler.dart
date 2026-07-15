import 'package:dio/dio.dart';

class NetworkErrorHandler {
  static String getErrorMessage(DioException e) {
    if (e.response == null) {
      return "No internet connection or server unreachable.";
    }

    final data = e.response?.data;

    if (data is Map && data.containsKey('message')) {
      return data['message'].toString();
    }
    if (data is Map && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      for (var entry in errors.values) {
        if (entry is List && entry.isNotEmpty) {
          return entry.first.toString();
        }
      }
    }

    // Fallback
    return "An unexpected error occurred (${e.response?.statusCode})";
  }
}

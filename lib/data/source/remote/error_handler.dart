import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getErrorMessage(DioException e) {
    if (e.response == null) {
      return "No internet connection or server unreachable.";
    }

    final data = e.response?.data;

    if (data is Map && data.containsKey('Message')) {
      return data['Message'].toString();
    }

    // Case 2: ASP.NET Core Validation format { "errors": { "Field": ["..."] } }
    if (data is Map && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      // Get the first error from the first field available
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

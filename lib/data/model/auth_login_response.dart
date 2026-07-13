import 'auth_user_profile.dart';

class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final DateTime? accessTokenExpiresAt;
  final DateTime? refreshTokenExpiresAt;
  final UserProfileModel? user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      accessTokenExpiresAt: _parseDate(json['accessTokenExpiresAt']),
      refreshTokenExpiresAt: _parseDate(json['refreshTokenExpiresAt']),
      user: json['user'] is Map<String, dynamic>
          ? UserProfileModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

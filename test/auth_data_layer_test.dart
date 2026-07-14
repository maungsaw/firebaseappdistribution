import 'package:firebaseappdistribution/data/dto/auth_login_request.dart';
import 'package:firebaseappdistribution/data/dto/auth_register_device_request.dart';
import 'package:firebaseappdistribution/data/model/api_response.dart';
import 'package:firebaseappdistribution/data/model/auth_login_response.dart';
import 'package:firebaseappdistribution/data/model/auth_register_device_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth DTOs', () {
    test('login request uses camelCase fields', () {
      final dto = LoginRequestDto(
        mobileNumber: '09123456789',
        password: 'secret',
      );

      expect(
        dto.toMap(),
        {
          'mobileNumber': '09123456789',
          'password': 'secret',
        },
      );
    });

    test('login request trims trailing spaces', () {
      final dto = LoginRequestDto(
        mobileNumber: ' +959123456789 ',
        password: 'Password123! ',
      );

      expect(dto.toMap(), {
        'mobileNumber': '+959123456789',
        'password': 'Password123!',
      });
    });

    test('register device request uses snake_case fields', () {
      const dto = RegisterDeviceRequestDto(
        deviceId: 'abc123',
        model: 'SM-A315G',
        fcmToken: 'token-1',
      );

      expect(
        dto.toMap(),
        {
          'device_id': 'abc123',
          'model': 'SM-A315G',
          'fcm_token': 'token-1',
        },
      );
    });
  });

  group('Auth models', () {
    test('login response parses wrapped api response', () {
      final response = ApiResponseModel.fromJson(
        {
          'success': true,
          'message': 'OK',
          'data': {
            'accessToken': 'access',
            'refreshToken': 'refresh',
            'user': {
              'id': 'user-1',
              'mobileNumber': '09123456789',
              'fullName': 'Agent One',
            },
          },
        },
        LoginResponseModel.fromJson,
      );

      expect(response.success, isTrue);
      expect(response.data?.accessToken, 'access');
      expect(response.data?.user?.mobileNumber, '09123456789');
    });

    test('register device response parses snake_case fields', () {
      final response = ApiResponseModel.fromJson(
        {
          'success': true,
          'data': {
            'id': '11111111-1111-1111-1111-111111111111',
            'device_id': 'abc123',
            'model': 'SM-A315G',
            'fcm_token': 'token-1',
            'isActive': true,
            'registeredAt': '2026-07-13T10:00:00Z',
          },
        },
        RegisterDeviceResponseModel.fromJson,
      );

      expect(response.data?.deviceId, 'abc123');
      expect(response.data?.isActive, isTrue);
      expect(response.data?.registeredAt, isNotNull);
    });
  });
}

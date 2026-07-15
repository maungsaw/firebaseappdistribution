import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';
import '../error_handler.dart';

class AuthServiceImpl extends BaseNetworkService<NetworkResponseModel>
    implements AuthService {
  AuthServiceImpl() : super(ClientEndPoint.auth);

  @override
  Future<NetworkResponseModel> login(LoginRequestDto request) async {
    try {
      final response = await createWithSuffix(
        suffix: ClientEndPoint.login,
        data: request.toMap(),
        fromJson: (json) =>
            NetworkResponseModel.fromJson(json, LoginResponseModel.fromJson),
        isProtected: false,
      );
      return response;
    } on DioException catch (e) {
      final message = NetworkErrorHandler.getErrorMessage(e);
      throw Exception(message);
    }
  }

  @override
  Future<NetworkResponseModel> registerDevice(
    RegisterDeviceRequestDto request,
  ) async {
    try {
      debugPrint(
        'Auth registerDevice → ${ApiClient.baseUrl}${ApiClient.clientVersion}'
        '${ClientEndPoint.joinPath(ClientEndPoint.auth, ClientEndPoint.devicesRegister)} '
        'body=${request.toMap()}',
      );
      final response = await createWithSuffix(
        suffix: ClientEndPoint.devicesRegister,
        data: request.toMap(),
        fromJson: (json) => NetworkResponseModel.fromJson(
          json,
          RegisterDeviceResponseModel.fromJson,
        ),
      );
      return response;
    } on DioException catch (e) {
      final message = NetworkErrorHandler.getErrorMessage(e);
      throw Exception(message);
    }
  }
}

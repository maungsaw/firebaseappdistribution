import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';

class AuthServiceImpl extends BaseNetworkService<ApiResponseModel>
    implements AuthService {
  AuthServiceImpl() : super(ClientEndPoint.auth);

  @override
  Future<ApiResponseModel> login(LoginRequestDto request) async {
    debugPrint(
      'Auth login → ${ApiClient.baseUrl}${ApiClient.clientVersion}'
      '${ClientEndPoint.joinPath(ClientEndPoint.auth, ClientEndPoint.login)} '
      'body=${request.toMap()}',
    );
    final response = await createWithSuffix(
      suffix: ClientEndPoint.login,
      data: request.toMap(),
      fromJson: (json) =>
          ApiResponseModel.fromJson(json, LoginResponseModel.fromJson),
      isProtected: false,
    );
    return response;
  }

  @override
  Future<ApiResponseModel> registerDevice(
    RegisterDeviceRequestDto request,
  ) async {
    debugPrint(
      'Auth registerDevice → ${ApiClient.baseUrl}${ApiClient.clientVersion}'
      '${ClientEndPoint.joinPath(ClientEndPoint.auth, ClientEndPoint.devicesRegister)} '
      'body=${request.toMap()}',
    );
    final response = await createWithSuffix(
      suffix: ClientEndPoint.devicesRegister,
      data: request.toMap(),
      fromJson: (json) =>
          ApiResponseModel.fromJson(json, RegisterDeviceResponseModel.fromJson),
    );
    return response;
  }
}

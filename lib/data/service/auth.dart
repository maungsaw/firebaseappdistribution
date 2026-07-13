import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';

class AuthService implements AuthServiceImp {
  final Dio _publicDio = NetworkClient.getClient(ClientServiceType.public);
  final Dio _protectedDio = NetworkClient.getClient(ClientServiceType.protected);

  @override
  Future<ApiResponseModel<LoginResponseModel>> login(
    LoginRequestDto request,
  ) async {
    final response = await _publicDio.post(
      ClientEndPoint.login,
      data: request.toMap(),
    );
    return ApiResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
      LoginResponseModel.fromJson,
    );
  }

  @override
  Future<ApiResponseModel<RegisterDeviceResponseModel>> registerDevice(
    RegisterDeviceRequestDto request,
  ) async {
    final response = await _protectedDio.post(
      ClientEndPoint.devicesRegister,
      data: request.toMap(),
    );
    return ApiResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
      RegisterDeviceResponseModel.fromJson,
    );
  }
}

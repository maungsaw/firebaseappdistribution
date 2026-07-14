import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';

class AuthServiceImpl extends BaseNetworkService<ApiResponseModel>
    implements AuthService {
  AuthServiceImpl() : super(ClientEndPoint.auth);

  @override
  Future<ApiResponseModel> login(LoginRequestDto request) async {
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
    final response = await createWithSuffix(
      suffix: ClientEndPoint.devicesRegister,
      data: request.toMap(),
      fromJson: (json) =>
          ApiResponseModel.fromJson(json, RegisterDeviceResponseModel.fromJson),
    );
    return response;
  }
}

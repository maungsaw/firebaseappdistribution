import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';

import '../error_handler.dart';

class RemoteWipeServiceImpl extends BaseNetworkService<NetworkResponseModel>
    implements RemoteWipeService {
  RemoteWipeServiceImpl() : super(ClientEndPoint.users);

  @override
  Future<NetworkResponseModel> wipeUser(String userId) async {
    try {
      return await createWithIdSuffix(
        id: userId.trim(),
        suffix: ClientEndPoint.wipe,
        fromJson: (json) => NetworkResponseModel.fromJson(
          json,
          UsersWipeResponseModel.fromJson,
        ),
      );
    } on DioException catch (e) {
      throw Exception(NetworkErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<NetworkResponseModel> wipeAck(WipeAckRequestDto request) async {
    try {
      final dio = NetworkClient.getClient(ClientServiceType.protected);
      final path = ClientEndPoint.joinPath(
        ClientEndPoint.devices,
        ClientEndPoint.wipeAck,
      );
      final response = await dio.post(
        path,
        data: request.toMap(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );
      return NetworkResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
        (_) => <String, dynamic>{},
      );
    } on DioException catch (e) {
      throw Exception(NetworkErrorHandler.getErrorMessage(e));
    }
  }
}

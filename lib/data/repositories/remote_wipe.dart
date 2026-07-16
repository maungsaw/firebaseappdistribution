import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class RemoteWipeRepositoryImpl implements RemoteWipeRepository {
  RemoteWipeRepositoryImpl({required this.service});

  final RemoteWipeService service;

  @override
  Future<UsersWipeResponseModel> wipeUser(String userId) async {
    final response = await service.wipeUser(userId);
    if (!response.success || response.data == null) {
      throw RemoteWipeFailure(response.message ?? 'Remote wipe failed');
    }
    return response.data! as UsersWipeResponseModel;
  }

  @override
  Future<void> wipeAck(WipeAckRequestDto request) async {
    final response = await service.wipeAck(request);
    if (!response.success) {
      throw RemoteWipeFailure(response.message ?? 'Wipe acknowledgement failed');
    }
  }
}

import 'package:firebaseappdistribution/data/data.dart';

abstract class RemoteWipeService {
  Future<NetworkResponseModel> wipeUser(String userId);

  Future<NetworkResponseModel> wipeAck(WipeAckRequestDto request);
}

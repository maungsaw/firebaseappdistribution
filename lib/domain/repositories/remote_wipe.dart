import 'package:firebaseappdistribution/data/data.dart';

abstract class RemoteWipeRepository {
  Future<UsersWipeResponseModel> wipeUser(String userId);

  Future<void> wipeAck(WipeAckRequestDto request);
}

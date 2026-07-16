import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class WipeUserUseCase {
  const WipeUserUseCase(this._repository);

  final RemoteWipeRepository _repository;

  Future<UsersWipeResponseModel> call({required String userId}) {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) {
      throw const RemoteWipeFailure('userId is required');
    }
    return _repository.wipeUser(trimmed);
  }
}

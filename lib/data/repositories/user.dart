import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class UserRepositoryImpl extends UserDAO implements UserRepository {
  @override
  Future<List<UserModel>> getAllUsers() async {
    return getAllDecrypted();
  }
}

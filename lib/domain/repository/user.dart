import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class UserRepository extends UserORM implements UserRepositoryImpl {
  @override
  Future<List<UserModel>> getAllUsers() async {
    await DatabaseManager().open();
    return getAllDecrypted();
  }
}

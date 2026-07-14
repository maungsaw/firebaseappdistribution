import 'package:firebaseappdistribution/data/data.dart';

abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();
}

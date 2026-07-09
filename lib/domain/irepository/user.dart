import 'package:firebaseappdistribution/data/data.dart';

abstract class UserRepositoryImpl {
  Future<List<UserModel>> getAllUsers();
}

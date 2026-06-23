import 'package:firebaseappdistribution/data/orm/database.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class PolicyRepository implements PolicyRepositoryImpl {
  final databaseManager = DatabaseManager.instance;

  @override
  Future<int> getAll() async => await databaseManager.getPolicyCount();
  @override
  Future<int> createPolicy(String no, String status) async =>
      await databaseManager.addPolicy(no, status);
}

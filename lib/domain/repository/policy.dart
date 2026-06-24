import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class PolicyRepository implements PolicyRepositoryImpl {
  final databaseManager = DatabaseManager();

  @override
  Future<List<PolicyModel>> getAll() async =>
      await databaseManager.getPolicys();
  @override
  Future<int> createPolicy(PolicyModel data) async =>
      await databaseManager.addPolicy(data);

  @override
  Future<int> removePolicy(int id) async =>
      await databaseManager.removePolicy(id);

  @override
  Future<int> updatePolicy(PolicyModel data) async =>
      await databaseManager.updatePolicy(data);
}

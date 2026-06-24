import 'package:firebaseappdistribution/data/data.dart' show PolicyModel;

abstract class PolicyRepositoryImpl {
  Future<int> createPolicy(PolicyModel data);
  Future<int> removePolicy(int id);
  Future<int> updatePolicy(PolicyModel data);
  Future<List<PolicyModel>> getAll();
}

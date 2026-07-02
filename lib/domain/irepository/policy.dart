import 'package:firebaseappdistribution/data/data.dart'
    show PolicyModel, PremiumTermModel, PremiumPolicyModel;

abstract class PolicyRepositoryImpl {
  Future<int> createPolicy(PolicyModel data);
  Future<int> removePolicy(int id);
  Future<int> updatePolicy(PolicyModel data);
  Future<double> getRates(int age, int term, String gender);
  Future<List<PolicyModel>> getAll();
  Future<List<PremiumTermModel>> getTerms();
  Future<List<PremiumPolicyModel>> getPolicies();
}

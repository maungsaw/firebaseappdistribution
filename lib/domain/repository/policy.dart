import 'package:firebaseappdistribution/data/data.dart'
    show PremiumPolicyORM, PolicyModel, PolicyORM, PremiumTermORM;
import 'package:firebaseappdistribution/data/model/master/premium_policy.dart';
import 'package:firebaseappdistribution/data/model/master/premium_term.dart';
import 'package:firebaseappdistribution/domain/domain.dart'
    show PolicyRepositoryImpl;

class PolicyRepository implements PolicyRepositoryImpl {
  final policyORM = PolicyORM();
  final premiumPolicyORM = PremiumPolicyORM();
  final premiumTermORM = PremiumTermORM();
  @override
  Future<List<PolicyModel>> getAll() async => await policyORM.getAll();
  @override
  Future<int> createPolicy(PolicyModel data) async =>
      await policyORM.insert(data);

  @override
  Future<int> removePolicy(int id) async => await policyORM.remove(id);

  @override
  Future<int> updatePolicy(PolicyModel data) async =>
      await policyORM.update(data, data.id!);

  @override
  Future<double> getRates(int age, int term, String gender) async =>
      policyORM.getPremiumRates(age, term, gender);

  @override
  Future<List<PremiumPolicyModel>> getPolicies() async =>
      await premiumPolicyORM.getAll();

  @override
  Future<List<PremiumTermModel>> getTerms() async =>
      await premiumTermORM.getAll();
}

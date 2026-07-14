import 'package:firebaseappdistribution/data/data.dart'
    show PremiumPolicyDAO, PolicyModel, PolicyDAO, PremiumTermDAO;
import 'package:firebaseappdistribution/data/model/master/premium_policy.dart';
import 'package:firebaseappdistribution/data/model/master/premium_term.dart';
import 'package:firebaseappdistribution/domain/domain.dart'
    show PolicyRepository;

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyDAO policyDAO;
  final PremiumPolicyDAO premiumPolicyDAO;
  final PremiumTermDAO premiumTermDAO;

  PolicyRepositoryImpl({
    required this.policyDAO,
    required this.premiumPolicyDAO,
    required this.premiumTermDAO,
  });
  @override
  Future<List<PolicyModel>> getAll() async => await policyDAO.getAll();
  @override
  Future<int> createPolicy(PolicyModel data) async =>
      await policyDAO.insert(data);

  @override
  Future<int> removePolicy(int id) async => await policyDAO.remove(id);

  @override
  Future<int> updatePolicy(PolicyModel data) async =>
      await policyDAO.update(data, data.id!);

  @override
  Future<double> getRates(int age, int term, String gender) async =>
      policyDAO.getPremiumRates(age, term, gender);

  @override
  Future<List<PremiumPolicyModel>> getPolicies() async =>
      await premiumPolicyDAO.getAll();

  @override
  Future<List<PremiumTermModel>> getTerms() async =>
      await premiumTermDAO.getAll();
}

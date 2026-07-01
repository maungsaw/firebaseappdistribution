import 'package:firebaseappdistribution/data/data.dart';

abstract class PremiumPolicyRepositoryImpl {
  Future<List<PremiumPolicyModel>> getAllTerms();
  Future<int> createTerm(PremiumPolicyModel data);
  Future<int> updateTerm(PremiumPolicyModel data, int id);
  Future<int> deleteTerm(int id);
}

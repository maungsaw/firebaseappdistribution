import 'package:firebaseappdistribution/data/data.dart';

abstract class PremiumTermRepository {
  Future<List<PremiumTermModel>> getAllTerms();
  Future<int> createTerm(PremiumTermModel data);
  Future<int> updateTerm(PremiumTermModel data, int id);
  Future<int> deleteTerm(int id);
}

import 'package:firebaseappdistribution/data/data.dart';

abstract class PremiumRateRepository {
  Future<int> createAll(List<PremiumRateModel> data);
  Future<PremiumRateModel?> getById(int id);
}

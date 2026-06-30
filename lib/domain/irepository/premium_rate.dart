import 'package:firebaseappdistribution/data/data.dart';

abstract class PremiumRateRepositoryImpl {
  Future<int> createAll(List<PremiumRateModel> data);
  Future<PremiumRateModel?> getById(int id);
}

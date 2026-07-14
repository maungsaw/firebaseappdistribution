import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PremiumRateRepositoryImpl extends PremiumRateDAO
    implements PremiumRateRepository {
  @override
  Future<int> createAll(List<PremiumRateModel> data) => super.insertAll(data);

  @override
  Future<Database> get database => DatabaseHelper().database;

  @override
  Future<PremiumRateModel?> getById(int id) => super.get(id);
}

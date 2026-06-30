import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PremiumRateRepository extends PremiumRateORM
    implements PremiumRateRepositoryImpl {
  @override
  Future<int> createAll(List<PremiumRateModel> data) => super.insertAll(data);

  @override
  Future<Database> get database => DatabaseManager().database;

  @override
  Future<PremiumRateModel?> getById(int id) => super.get(id);
}

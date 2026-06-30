import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PremiumTermRepository extends PremiumTermORM
    implements PremiumTermRepositoryImpl {
  @override
  Future<int> createTerm(PremiumTermModel data) async =>
      await super.insert(data);

  @override
  Future<int> deleteTerm(int id) async => await super.remove(id);

  @override
  Future<List<PremiumTermModel>> getAllTerms() async => await super.getAll();

  @override
  Future<int> updateTerm(PremiumTermModel data, int id) async =>
      await super.update(data, id);

  @override
  Future<Database> get database => DatabaseManager().database;
}

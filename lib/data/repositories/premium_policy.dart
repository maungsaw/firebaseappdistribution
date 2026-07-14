import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PremiumPolicyRepositoryImpl extends PremiumPolicyDAO
    implements PremiumPolicyRepository {
  @override
  Future<int> createTerm(PremiumPolicyModel data) async =>
      await super.insert(data);

  @override
  Future<int> deleteTerm(int id) async => await super.remove(id);

  @override
  Future<List<PremiumPolicyModel>> getAllTerms() async => await super.getAll();

  @override
  Future<int> updateTerm(PremiumPolicyModel data, int id) async =>
      await super.update(data, id);

  @override
  Future<Database> get database => DatabaseHelper().database;
}

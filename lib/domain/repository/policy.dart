import 'package:firebaseappdistribution/data/data.dart'
    show PolicyORM, PolicyModel, DatabaseManager;
import 'package:firebaseappdistribution/domain/domain.dart'
    show PolicyRepositoryImpl;
import 'package:sqflite_common/sqlite_api.dart';

class PolicyRepository extends PolicyORM implements PolicyRepositoryImpl {
  @override
  Future<List<PolicyModel>> getAll() async => await super.getAll();
  @override
  Future<int> createPolicy(PolicyModel data) async => await super.insert(data);

  @override
  Future<int> removePolicy(int id) async => await super.remove(id);

  @override
  Future<int> updatePolicy(PolicyModel data) async =>
      await super.update(data, data.id!);

  @override
  Future<Database> get database => DatabaseManager().database;
}

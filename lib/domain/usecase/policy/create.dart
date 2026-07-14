import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class CreatePolicyUseCase {
  final PolicyRepository repository;

  CreatePolicyUseCase({required this.repository});
  Future<int> call(PolicyModel data) async {
    if (data.sumAssured <= 0) throw Exception("Invalid amount");
    return await repository.createPolicy(data);
  }
}

import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class GetAllPoliciesUseCase {
  final PolicyRepository repository;

  GetAllPoliciesUseCase({required this.repository});
  Future<List<PolicyModel>> call() async => await repository.getAll();
}

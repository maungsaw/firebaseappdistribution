import 'package:firebaseappdistribution/domain/domain.dart';

class RemovePolicyUseCase {
  final PolicyRepository repository;

  RemovePolicyUseCase({required this.repository});

  Future<int> call(int id) async => await repository.removePolicy(id);
}

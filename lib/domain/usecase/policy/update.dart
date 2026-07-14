import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';

class UpdatePolicyUseCase {
  final PolicyRepository repository;

  UpdatePolicyUseCase({required this.repository});
  Future<int> call(PolicyModel data) {
    if (data.id == null) throw Exception('Id should not be null or empty');
    return repository.updatePolicy(data);
  }
}

import 'package:firebaseappdistribution/domain/domain.dart';

class GetRatesUseCase {
  final PolicyRepository repository;

  GetRatesUseCase({required this.repository});

  Future<double> call(int age, int term, String gender) async =>
      await repository.getRates(age, term, gender);
}

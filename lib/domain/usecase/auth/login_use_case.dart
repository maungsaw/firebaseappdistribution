import 'package:firebaseappdistribution/data/dto/request/auth_login_request.dart';
import 'package:firebaseappdistribution/data/dto/response/auth_login_response.dart';
import 'package:firebaseappdistribution/domain/repositories/auth.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginResponseModel> call({
    required String mobileNumber,
    required String password,
  }) {
    if (mobileNumber.isEmpty || password.isEmpty) {
      throw Exception('Pls fill form');
    }
    return _repository.login(
      LoginRequestDto(
        mobileNumber: mobileNumber.trim(),
        password: password.trim(),
      ),
    );
  }
}

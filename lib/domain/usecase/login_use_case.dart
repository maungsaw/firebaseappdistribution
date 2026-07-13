import 'package:firebaseappdistribution/data/dto/auth_login_request.dart';
import 'package:firebaseappdistribution/data/model/auth_login_response.dart';
import 'package:firebaseappdistribution/domain/irepository/auth.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepositoryImpl _repository;

  Future<LoginResponseModel> call({
    required String mobileNumber,
    required String password,
  }) {
    return _repository.login(
      LoginRequestDto(
        mobileNumber: mobileNumber,
        password: password,
      ),
    );
  }
}

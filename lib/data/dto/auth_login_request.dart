class LoginRequestDto {
  final String mobileNumber;
  final String password;

  LoginRequestDto({
    required String mobileNumber,
    required String password,
  })  : mobileNumber = mobileNumber.trim(),
        password = password.trim();

  Map<String, dynamic> toMap() => {
        'mobileNumber': mobileNumber,
        'password': password,
      };
}

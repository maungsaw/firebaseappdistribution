class LoginRequestDto {
  final String mobileNumber;
  final String password;

  const LoginRequestDto({
    required this.mobileNumber,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'mobileNumber': mobileNumber,
        'password': password,
      };
}

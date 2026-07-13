sealed class AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  LoginSubmittedEvent({
    required this.mobileNumber,
    required this.password,
  });

  final String mobileNumber;
  final String password;
}

class RegisterDeviceSubmittedEvent extends AuthEvent {}

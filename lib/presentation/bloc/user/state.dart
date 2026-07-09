import 'package:firebaseappdistribution/data/data.dart';

sealed class UserState {
  final List<UserModel> data;
  final bool isLoading;
  final String message;

  UserState({
    required this.data,
    required this.isLoading,
    required this.message,
  });
}

class InitialUserState extends UserState {
  InitialUserState({
    super.data = const [],
    super.isLoading = false,
    super.message = 'init',
  });
}

class LoadingUserState extends UserState {
  LoadingUserState({
    super.data = const [],
    super.isLoading = true,
    super.message = 'loading',
  });
}

class FailureUserState extends UserState {
  final String errorMessage;
  FailureUserState({required this.errorMessage})
    : super(data: const [], isLoading: false, message: errorMessage);
}

class SuccessUserState extends UserState {
  final List<UserModel> users;

  SuccessUserState({required this.users})
    : super(data: users, isLoading: false, message: 'success');
}

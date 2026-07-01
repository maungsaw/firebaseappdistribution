import 'package:firebaseappdistribution/data/data.dart';

sealed class PolicyState {
  final List<PolicyModel> data;
  final bool loading;
  final String message;

  PolicyState({
    this.data = const [],
    this.message = "Init",
    this.loading = true,
  });
}

class InitialPolicyState extends PolicyState {
  InitialPolicyState({super.loading = false});
}

class LoadingPolicyState extends PolicyState {
  LoadingPolicyState({super.loading = true});
}

class SuccessPolicyState extends PolicyState {}

class ErrorPolicyState extends PolicyState {
  ErrorPolicyState(String errorMessage) : super(message: errorMessage);
}

class FetchPolicyState extends PolicyState {
  FetchPolicyState(List<PolicyModel> d) : super(data: d, loading: false);
}

class PremiumOptionsLoadedState extends PolicyState {
  final List<PremiumTermModel> terms;
  final List<PremiumPolicyModel> policies;
  PremiumOptionsLoadedState({required this.terms, required this.policies});
}

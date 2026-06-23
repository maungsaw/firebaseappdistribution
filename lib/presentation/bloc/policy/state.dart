sealed class PolicyState {
  final int? data;
  final bool loading;
  final String message;

  PolicyState({this.data, this.message = "Init", this.loading = true});
}

class InitialPolicyState extends PolicyState {
  InitialPolicyState({super.loading = false});
}

class LoadingPolicyState extends PolicyState {
  LoadingPolicyState({super.loading = true});
}

class ErrorPolicyState extends PolicyState {
  ErrorPolicyState(String errorMessage) : super(message: errorMessage);
}

class SuccessPolicyState extends PolicyState {
  SuccessPolicyState(int d) : super(data: d, loading: false);
}

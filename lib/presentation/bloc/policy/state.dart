sealed class PolicyState<T> {
  final T? data;
  final bool loading;
  final String message;

  PolicyState({this.data, this.message = "Init", this.loading = true});
}

class InitialPolicyState<T> extends PolicyState<T> {
  InitialPolicyState({super.loading = false});
}

class LoadingPolicyState<T> extends PolicyState<T> {
  LoadingPolicyState({super.loading = true});
}

class ErrorPolicyState<T> extends PolicyState<T> {
  ErrorPolicyState(String errorMessage) : super(message: errorMessage);
}

class SuccessPolicyState<T> extends PolicyState<T> {
  SuccessPolicyState(T d) : super(data: d, loading: false);
}

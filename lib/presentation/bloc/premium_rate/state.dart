sealed class PremiumRateState {
  final int count;
  final bool isLoading;
  final String message;

  PremiumRateState({
    this.count = 0,
    required this.isLoading,
    required this.message,
  });
}

class InitialPremiumRateState extends PremiumRateState {
  InitialPremiumRateState({super.isLoading = false, super.message = 'initial'});
}

class LoadingPremiumRateState extends PremiumRateState {
  LoadingPremiumRateState({super.isLoading = true, super.message = 'loading'});
}

class FailurePremiumRateState extends PremiumRateState {
  final String errorMessage;

  FailurePremiumRateState({required this.errorMessage})
    : super(isLoading: false, message: errorMessage);
}

class SuccessPremiumRateState extends PremiumRateState {
  final int successCount;

  SuccessPremiumRateState({required this.successCount})
    : super(isLoading: false, message: 'success', count: successCount);
}

import 'package:firebaseappdistribution/data/data.dart';

sealed class PremiumPolicyState {
  final List<PremiumPolicyModel> data;
  final bool isLoading;
  final String message;

  PremiumPolicyState({
    required this.data,
    required this.isLoading,
    required this.message,
  });
}

class InitialPremiumPolicyState extends PremiumPolicyState {
  InitialPremiumPolicyState({
    super.data = const [],
    super.isLoading = false,
    super.message = 'init',
  });
}

class LoadingPremiumPolicyState extends PremiumPolicyState {
  LoadingPremiumPolicyState({
    super.data = const [],
    super.isLoading = true,
    super.message = 'loading',
  });
}

class FailurePremiumPolicyState extends PremiumPolicyState {
  final String errorMessage;
  FailurePremiumPolicyState({required this.errorMessage})
    : super(data: const [], isLoading: false, message: errorMessage);
}

class SuccessPremiumPolicyState extends PremiumPolicyState {
  final List<PremiumPolicyModel> premiumPolicys;

  SuccessPremiumPolicyState({required this.premiumPolicys})
    : super(data: premiumPolicys, isLoading: false, message: 'success');
}

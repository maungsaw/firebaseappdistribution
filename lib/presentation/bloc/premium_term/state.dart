import 'package:firebaseappdistribution/data/data.dart';

sealed class PremiumTermState {
  final List<PremiumTermModel> data;
  final bool isLoading;
  final String message;

  PremiumTermState({
    required this.data,
    required this.isLoading,
    required this.message,
  });
}

class InitialPremiumTermState extends PremiumTermState {
  InitialPremiumTermState({
    super.data = const [],
    super.isLoading = false,
    super.message = 'init',
  });
}

class LoadingPremiumTermState extends PremiumTermState {
  LoadingPremiumTermState({
    super.data = const [],
    super.isLoading = true,
    super.message = 'loading',
  });
}

class FailurePremiumTermState extends PremiumTermState {
  final String errorMessage;
  FailurePremiumTermState({required this.errorMessage})
    : super(data: const [], isLoading: false, message: errorMessage);
}

class SuccessPremiumTermState extends PremiumTermState {
  final List<PremiumTermModel> premiumTerms;

  SuccessPremiumTermState({required this.premiumTerms})
    : super(data: premiumTerms, isLoading: false, message: 'success');
}

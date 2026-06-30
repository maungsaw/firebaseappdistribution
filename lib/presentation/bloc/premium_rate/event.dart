sealed class PremiumRateEvent {}

class ImportedPremiumRateEvent extends PremiumRateEvent {
  final String path;

  ImportedPremiumRateEvent({required this.path});
}

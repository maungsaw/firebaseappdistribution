import 'package:firebaseappdistribution/data/data.dart';

sealed class PremiumTermEvent {}

class FetchedPremiumTermEvent extends PremiumTermEvent {}

class ReorderPremiumTermEvent extends PremiumTermEvent {
  final List<PremiumTermModel> updatedList;

  ReorderPremiumTermEvent({required this.updatedList});
}

class CreatePremiumTermEvent extends PremiumTermEvent {
  final PremiumTermModel premiumTermModel;

  CreatePremiumTermEvent({required this.premiumTermModel});
}

class UpdatePremiumTermEvent extends PremiumTermEvent {
  final PremiumTermModel premiumTermModel;
  final int id;

  UpdatePremiumTermEvent({required this.premiumTermModel, required this.id});
}

class DeletePremiumTermEvent extends PremiumTermEvent {
  final int id;

  DeletePremiumTermEvent({required this.id});
}

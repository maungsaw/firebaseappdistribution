import 'package:firebaseappdistribution/data/data.dart';

sealed class PremiumPolicyEvent {}

class FetchedPremiumPolicyEvent extends PremiumPolicyEvent {}

class ReorderPremiumPolicyEvent extends PremiumPolicyEvent {
  final List<PremiumPolicyModel> updatedList;

  ReorderPremiumPolicyEvent({required this.updatedList});
}

class CreatePremiumPolicyEvent extends PremiumPolicyEvent {
  final PremiumPolicyModel premiumPolicyModel;

  CreatePremiumPolicyEvent({required this.premiumPolicyModel});
}

class UpdatePremiumPolicyEvent extends PremiumPolicyEvent {
  final PremiumPolicyModel premiumPolicyModel;
  final int id;

  UpdatePremiumPolicyEvent({
    required this.premiumPolicyModel,
    required this.id,
  });
}

class DeletePremiumPolicyEvent extends PremiumPolicyEvent {
  final int id;

  DeletePremiumPolicyEvent({required this.id});
}

import 'package:firebaseappdistribution/data/data.dart';

sealed class PolicyEvent {}

class SuccessPolicyEvent extends PolicyEvent {}

class NewPolicyEvent extends PolicyEvent {
  final PolicyModel policyModel;
  NewPolicyEvent(this.policyModel);
}

class UpdatePolicyEvent extends PolicyEvent {
  final PolicyModel policy;
  UpdatePolicyEvent(this.policy);
}

class RemovePolicyEvent extends PolicyEvent {
  final int id;
  RemovePolicyEvent(this.id);
}

class LoadPremiumOptionsEvent extends PolicyEvent {
  final int age;
  LoadPremiumOptionsEvent(this.age);
}

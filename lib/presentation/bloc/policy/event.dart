import 'package:firebaseappdistribution/data/data.dart';

sealed class PolicyEvent {}

class SuccessPolicyEvent extends PolicyEvent {}

class NewPolicyEvent extends PolicyEvent {
  final String no;
  final String status;
  NewPolicyEvent(this.no, this.status);
}

class UpdatePolicyEvent extends PolicyEvent {
  final PolicyModel policy;
  UpdatePolicyEvent(this.policy);
}

class RemovePolicyEvent extends PolicyEvent {
  final int id;
  RemovePolicyEvent(this.id);
}

sealed class PolicyEvent {}

class SuccessPolicyEvent extends PolicyEvent {}

class NewPolicyEvent extends PolicyEvent {
  final String no;
  final String status;
  NewPolicyEvent(this.no, this.status);
}

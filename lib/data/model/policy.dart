class PolicyModel {
  final int? id;
  final String no;
  final String status;
  PolicyModel({this.id, required this.no, required this.status});

  Map<String, dynamic> toMap() {
    return {'id': id, 'policy_no': no, 'status': status};
  }

  factory PolicyModel.fromMap(Map<String, dynamic> map) {
    return PolicyModel(
      id: map['id'] ?? 0,
      no: map['policy_no'] ?? "",
      status: map['status'] ?? "",
    );
  }

  PolicyModel copyWith({int? id, String? no, String? status}) {
    return PolicyModel(
      id: id ?? this.id,
      no: no ?? this.no,
      status: status ?? this.status,
    );
  }
}

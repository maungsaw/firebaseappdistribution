class PolicyModel {
  final int? id;
  final String no;
  final String status;
  final String filePath;
  PolicyModel({
    this.id,
    required this.no,
    required this.status,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'policy_no': no, 'status': status, 'file_path': filePath};
  }

  factory PolicyModel.fromMap(Map<String, dynamic> map) {
    return PolicyModel(
      id: map['id'] ?? 0,
      no: map['policy_no'] ?? "",
      status: map['status'] ?? "",
      filePath: map['file_path'] ?? "",
    );
  }

  PolicyModel copyWith({
    int? id,
    String? no,
    String? status,
    String? filePath,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      no: no ?? this.no,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
    );
  }
}

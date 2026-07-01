import 'package:flutter/rendering.dart';

class PolicyModel {
  final int? id;
  final String no;
  final String status;
  final String filePath;
  final DateTime birthday;
  final int age;
  final String name;
  final double sumAssured;
  final double premiumAmount;
  final int termId;
  final int policyId;
  PolicyModel({
    this.id,
    required this.no,
    required this.status,
    required this.filePath,
    required this.birthday,
    required this.age,
    required this.name,
    required this.sumAssured,
    required this.premiumAmount,
    required this.termId,
    required this.policyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'policy_no': no,
      'status': status,
      'file_path': filePath,
      'birthday': birthday.toString(),
      'age': age,
      'name': name,
      'sum_assured': sumAssured,
      'premium_amount': premiumAmount,
      'term_id': termId,
      'policy_id': policyId,
    };
  }

  factory PolicyModel.fromMap(Map<String, dynamic> map) {
    debugPrint('${map['birthday']}');
    return PolicyModel(
      id: map['id'] ?? 0,
      no: map['policy_no'] ?? "",
      status: map['status'] ?? "",
      filePath: map['file_path'] ?? "",
      birthday: DateTime.parse(map['birthday']),
      age: map['age'],
      name: map['name'],
      sumAssured: map['sum_assured'],
      premiumAmount: map['premium_amount'],
      termId: map['term_id'],
      policyId: map['policy_id'],
    );
  }

  PolicyModel copyWith({
    int? id,
    String? no,
    String? status,
    String? filePath,
    String? name,
    int? age,
    DateTime? birthday,
    double? sumAssured,
    double? premiumAmount,
    int? termId,
    int? policyId,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      no: no ?? this.no,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      birthday: birthday ?? this.birthday,
      age: age ?? this.age,
      name: name ?? this.name,
      sumAssured: sumAssured ?? this.sumAssured,
      premiumAmount: premiumAmount ?? this.premiumAmount,
      termId: termId ?? this.termId,
      policyId: policyId ?? this.policyId,
    );
  }
}

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
  final int term;
  final double policy;
  final String gender;
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
    required this.term,
    required this.policy,
    required this.gender,
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
      'term': term,
      'policy': policy,
      'gender': gender,
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
      term: map['term'],
      policy: map['policy'],
      gender: map['gender'],
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
    int? term,
    double? policy,
    String? gender,
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
      term: term ?? this.term,
      policy: policy ?? this.policy,
      gender: gender ?? this.gender,
    );
  }
}

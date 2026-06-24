import 'package:firebaseappdistribution/core/core.dart' show FormType;
import 'package:firebaseappdistribution/data/data.dart' show PolicyModel;
import 'form.dart';
import 'package:flutter/material.dart';

class PolicyDetailScreen extends StatelessWidget {
  final PolicyModel policy;
  const PolicyDetailScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Policy Detail')),
      body: PolicyForm(type: FormType.detail, data: policy),
    );
  }
}

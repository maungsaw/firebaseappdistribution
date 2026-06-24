import 'package:firebaseappdistribution/core/core.dart' show FormType;
import 'package:firebaseappdistribution/data/data.dart' show PolicyModel;
import './form.dart';
import 'package:flutter/material.dart';

class EditPolicyScreen extends StatelessWidget {
  final PolicyModel policy;
  const EditPolicyScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Policy')),
      body: PolicyForm(type: FormType.edit, data: policy),
    );
  }
}

import 'package:firebaseappdistribution/core/core.dart' show FormType;
import 'form.dart';
import 'package:flutter/material.dart';

class CreatePolicyScreen extends StatelessWidget {
  const CreatePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Policy')),
      body: PolicyForm(type: FormType.create),
    );
  }
}

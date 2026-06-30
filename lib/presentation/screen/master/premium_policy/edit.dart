import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/material.dart';

class EditPremiumPolicyScreen extends StatelessWidget {
  final PremiumPolicyModel data;
  const EditPremiumPolicyScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Edit Premium Policy')));
  }
}

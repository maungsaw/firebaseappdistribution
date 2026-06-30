import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/material.dart';

class PremiumPolicyDetailScreen extends StatelessWidget {
  final PremiumPolicyModel? data;
  const PremiumPolicyDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Premium Policy Detail')));
  }
}

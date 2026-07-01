import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/material.dart';

class PremiumPolicyDetailScreen extends StatelessWidget {
  final PremiumPolicyModel? data;
  const PremiumPolicyDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Policy Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Label: ${data?.label}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Value: ${data?.value}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

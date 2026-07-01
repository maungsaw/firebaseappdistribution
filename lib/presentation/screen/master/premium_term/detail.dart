import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/material.dart';

class PremiumTermDetailScreen extends StatelessWidget {
  final PremiumTermModel data;
  const PremiumTermDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Term Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Label: ${data.label}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Value: ${data.value}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

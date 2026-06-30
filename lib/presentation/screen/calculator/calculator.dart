import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      floatingActionButton: FilePickerView(
        extensions: ['xlsx'],
        onPickDocument: (String path) async {
          final result = await ExcelReader.readPremiumRate(
            path: path,
            columns: [
              'FromAge',
              'ToAge',
              'Gender',
              'PremiumTerm',
              'Premium Rate',
            ],
            sheets: ['Male', 'Female'],
            fromMap: (map) => PremiumConfig.fromMap(map),
          );
          debugPrint('RESULT -> ${result.length}');
        },
      ),
    );
  }
}

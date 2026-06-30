import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: BlocListener<PremiumRateBloc, PremiumRateState>(
        listener: (context, state) {
          if (state is FailurePremiumRateState) {
            GlobalSnackbar.showError(context, state.errorMessage);
          }
        },
        child: Text('Hello'),
      ),
      floatingActionButton: FilePickerView(
        label: 'Import Excel',
        extensions: ['xlsx'],
        onPickDocument: (String path) async {
          context.read<PremiumRateBloc>().add(
            ImportedPremiumRateEvent(path: path),
          );
        },
      ),
    );
  }
}

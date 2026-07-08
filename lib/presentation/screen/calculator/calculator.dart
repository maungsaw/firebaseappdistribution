import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final signatureController = CustomSignatureController();

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          // Clear Action Function executed on the AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => signatureController.clear(),
          ),
          // Save Action Function executed on the AppBar
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final result = await signatureController.export(
                format: SignatureExportFormat.png,
                exportSize: const Size(600, 400),
              );

              if (result != null && result.bytes != null) {
                // Done! Got your PNG bytes outside of the Canvas Pad context
                debugPrint("Exported bytes length: ${result.bytes!.length}");
              }
            },
          ),
        ],
      ),

      body: BlocListener<PremiumRateBloc, PremiumRateState>(
        listener: (context, state) {
          if (state is FailurePremiumRateState) {
            GlobalSnackbar.showError(context, state.errorMessage);
          }
          if (state is SuccessPremiumRateState) {
            GlobalSnackbar.showSuccess(context, state.message);
          }
        },
        child: Column(
          children: [
            CustomSignaturePad(
              controller: signatureController,
              canvasColor: Colors.white,
              penColor: Colors.black,
              padSize: Size.fromHeight(200.0), // Pass it down
            ),
          ],
        ),
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

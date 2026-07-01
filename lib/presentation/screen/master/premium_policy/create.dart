import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'form.dart';

class CreatePremiumPolicyScreen extends StatelessWidget {
  const CreatePremiumPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Premium Policy')),
      body: SingleChildScrollView(
        padding: .all(16),
        child: BlocListener<PremiumPolicyBloc, PremiumPolicyState>(
          listener: (BuildContext context, PremiumPolicyState state) {
            if (state is SuccessPremiumPolicyState) {
              context.pop();
            }
            if (state is FailurePremiumPolicyState) {
              GlobalSnackbar.showError(context, state.errorMessage);
            }
          },
          child: PremiumPolicyForm(
            formType: FormType.create.name,
            onSave: (d) {
              context.read<PremiumPolicyBloc>().add(
                CreatePremiumPolicyEvent(premiumPolicyModel: d!),
              );
            },
          ),
        ),
      ),
    );
  }
}

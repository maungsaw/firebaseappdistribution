import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/bloc/premium_term/premium_term.dart';
import 'package:firebaseappdistribution/presentation/screen/master/premium_term/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePremiumTermScreen extends StatelessWidget {
  const CreatePremiumTermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Premium Term')),
      body: SingleChildScrollView(
        padding: .all(16),
        child: BlocListener<PremiumTermBloc, PremiumTermState>(
          listener: (BuildContext context, PremiumTermState state) {
            if (state is SuccessPremiumTermState) {
              context.pop();
            }
            if (state is FailurePremiumTermState) {
              GlobalSnackbar.showError(context, state.errorMessage);
            }
          },
          child: PremiumTermForm(
            formType: FormType.create.name,
            onSave: (d) {
              context.read<PremiumTermBloc>().add(
                CreatePremiumTermEvent(premiumTermModel: d!),
              );
            },
          ),
        ),
      ),
    );
  }
}

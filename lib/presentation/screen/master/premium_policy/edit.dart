import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'form.dart';

class EditPremiumPolicyScreen extends StatelessWidget {
  final PremiumPolicyModel data;
  const EditPremiumPolicyScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Premium Policy')),
      body: SingleChildScrollView(
        padding: .all(16),
        child: BlocListener<PremiumPolicyBloc, PremiumPolicyState>(
          listener: (context, state) {
            if (state is SuccessPremiumPolicyState) {
              context.pop();
            }
          },
          child: PremiumPolicyForm(
            formType: FormType.edit.name,
            onSave: (d) {
              context.read<PremiumPolicyBloc>().add(
                UpdatePremiumPolicyEvent(premiumPolicyModel: d!, id: d.id!),
              );
            },
            data: data,
            saveButtonText: 'Update',
          ),
        ),
      ),
    );
  }
}

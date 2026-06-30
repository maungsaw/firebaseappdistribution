import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/model/master/master.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:firebaseappdistribution/presentation/screen/master/premium_term/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditPremiumTermScreen extends StatelessWidget {
  final PremiumTermModel data;
  const EditPremiumTermScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Premium Term')),
      body: SingleChildScrollView(
        padding: .all(16),
        child: BlocListener<PremiumTermBloc, PremiumTermState>(
          listener: (context, state) {
            if (state is SuccessPremiumTermState) {
              context.pop();
            }
          },
          child: PremiumTermForm(
            formType: FormType.edit.name,
            onSave: (d) {
              context.read<PremiumTermBloc>().add(
                UpdatePremiumTermEvent(premiumTermModel: d!, id: d.id!),
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

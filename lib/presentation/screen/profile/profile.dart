import 'package:firebaseappdistribution/presentation/bloc/policy/bloc.dart';
import 'package:firebaseappdistribution/presentation/bloc/policy/state.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PolicyBloc, PolicyState>(
      builder: (context, state) {
        if (state is LoadingPolicyState) return GlobalWidget.loadingView();
        if (state is SuccessPolicyState) {
          return Center(child: Text('${state.data}'));
        }
        return GlobalWidget.errorView(state.message);
      },
      listener: (BuildContext context, PolicyState<dynamic> state) {},
    );
  }
}

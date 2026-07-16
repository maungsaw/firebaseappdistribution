import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import '../../presentation/presentation.dart';

class BlocDependencies extends StatelessWidget {
  final Widget child;

  const BlocDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: Injection.sl<BottomAppbarBloc>()),
        BlocProvider.value(value: Injection.sl<FilePickerBloc>()),
        BlocProvider.value(value: Injection.sl<PolicyBloc>()),
        BlocProvider.value(value: Injection.sl<PremiumRateBloc>()),
        BlocProvider.value(value: Injection.sl<PremiumTermBloc>()),
        BlocProvider.value(value: Injection.sl<PremiumPolicyBloc>()),
        BlocProvider.value(value: Injection.sl<UserBloc>()),
        BlocProvider.value(value: Injection.sl<AuthBloc>()),
      ],
      child: child,
    );
  }
}

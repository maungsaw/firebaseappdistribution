import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import 'presentation/presentation.dart';

class AppDependencies extends StatelessWidget {
  final Widget child;

  const AppDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BottomAppbarBloc>()),
        BlocProvider(create: (_) => sl<FilePickerBloc>()),
        BlocProvider(create: (_) => sl<PolicyBloc>()),
        BlocProvider(create: (_) => sl<WeatherBloc>()),
        BlocProvider(create: (_) => sl<PremiumRateBloc>()),
        BlocProvider(create: (_) => sl<PremiumTermBloc>()),
        BlocProvider(create: (_) => sl<PremiumPolicyBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
      ],
      child: child,
    );
  }
}

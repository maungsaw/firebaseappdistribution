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
        BlocProvider(create: (_) => Injection.sl<BottomAppbarBloc>()),
        BlocProvider(create: (_) => Injection.sl<FilePickerBloc>()),
        BlocProvider(create: (_) => Injection.sl<PolicyBloc>()),
        BlocProvider(create: (_) => Injection.sl<WeatherBloc>()),
        BlocProvider(create: (_) => Injection.sl<PremiumRateBloc>()),
        BlocProvider(create: (_) => Injection.sl<PremiumTermBloc>()),
        BlocProvider(create: (_) => Injection.sl<PremiumPolicyBloc>()),
        BlocProvider(create: (_) => Injection.sl<UserBloc>()),
        BlocProvider(create: (_) => Injection.sl<AuthBloc>()),
      ],
      child: child,
    );
  }
}

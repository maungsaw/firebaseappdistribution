import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data.dart';
import 'domain/domain.dart';
import 'core/core.dart';
import 'presentation/presentation.dart';

class AppDependencies extends StatelessWidget {
  final Widget child;

  const AppDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(
          create: (_) => NetworkClient.getClient(ClientServiceType.protected),
        ),
        RepositoryProvider<WeatherServiceImp>(
          create: (ctx) => WeatherService(),
        ),
        RepositoryProvider<WeatherRepositoryImpl>(
          create: (ctx) =>
              WeatherRepository(service: ctx.read<WeatherServiceImp>()),
        ),
        RepositoryProvider<PolicyRepositoryImpl>(
          create: (_) => PolicyRepository(),
        ),
        RepositoryProvider<PremiumRateRepositoryImpl>(
          create: (_) => PremiumRateRepository(),
        ),
        RepositoryProvider<PremiumPolicyRepositoryImpl>(
          create: (_) => PremiumPolicyRepository(),
        ),
        RepositoryProvider<PremiumTermRepositoryImpl>(
          create: (_) => PremiumTermRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BottomAppbarBloc()),
          BlocProvider(create: (_) => FilePickerBloc()),
          BlocProvider(
            create: (ctx) =>
                PolicyBloc(policyRepository: ctx.read<PolicyRepositoryImpl>()),
          ),
          BlocProvider(
            create: (ctx) => WeatherBloc(
              weatherRepository: ctx.read<WeatherRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => PremiumRateBloc(
              repository: ctx.read<PremiumRateRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => PremiumTermBloc(
              repository: ctx.read<PremiumTermRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => PremiumPolicyBloc(
              repository: ctx.read<PremiumPolicyRepositoryImpl>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

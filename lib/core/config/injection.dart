import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../core.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';
import '../../presentation/presentation.dart';

abstract class Injection {
  static final sl = GetIt.instance;

  static void initInjector() {
    _initDAO();
    _initNetwork();
    _initRepositories();
    _initUseCases();
    _initBlocs();
  }
}

// --- DAO ---
void _initDAO() {
  Injection.sl.registerLazySingleton(() => PolicyDAO());
  Injection.sl.registerLazySingleton(() => PremiumPolicyDAO());
  Injection.sl.registerLazySingleton(() => PremiumTermDAO());
}

// --- Network ---
void _initNetwork() {
  Injection.sl.registerLazySingleton(() => AppTalker.instance);
  Injection.sl.registerLazySingleton<Dio>(
    () => NetworkClient.getClient(ClientServiceType.protected),
  );
  Injection.sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
}

// --- Repositories ---
void _initRepositories() {
  Injection.sl.registerLazySingleton<PolicyRepository>(
    () => PolicyRepositoryImpl(
      policyDAO: Injection.sl(),
      premiumPolicyDAO: Injection.sl(),
      premiumTermDAO: Injection.sl(),
    ),
  );
  Injection.sl.registerLazySingleton<PremiumRateRepository>(
    () => PremiumRateRepositoryImpl(),
  );
  Injection.sl.registerLazySingleton<PremiumPolicyRepository>(
    () => PremiumPolicyRepositoryImpl(),
  );
  Injection.sl.registerLazySingleton<PremiumTermRepository>(
    () => PremiumTermRepositoryImpl(),
  );
  Injection.sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(),
  );
  Injection.sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: Injection.sl()),
  );
}

// --- UseCases ---
void _initUseCases() {
  Injection.sl.registerLazySingleton(() => LoginUseCase(Injection.sl()));
  Injection.sl.registerLazySingleton(
    () => RegisterDeviceUseCase(Injection.sl()),
  );
  Injection.sl.registerLazySingleton(
    () => CreatePolicyUseCase(repository: Injection.sl()),
  );
  Injection.sl.registerLazySingleton(
    () => UpdatePolicyUseCase(repository: Injection.sl()),
  );
  Injection.sl.registerLazySingleton(
    () => RemovePolicyUseCase(repository: Injection.sl()),
  );
  Injection.sl.registerLazySingleton(
    () => GetAllPoliciesUseCase(repository: Injection.sl()),
  );
  Injection.sl.registerLazySingleton(
    () => GetRatesUseCase(repository: Injection.sl()),
  );
}

// --- Blocs ---
void _initBlocs() {
  Injection.sl.registerFactory(() => BottomAppbarBloc());
  Injection.sl.registerFactory(() => FilePickerBloc());
  Injection.sl.registerFactory(
    () => PolicyBloc(
      createPolicyUseCase: Injection.sl(),
      removePolicyUseCase: Injection.sl(),
      updatePolicyUseCase: Injection.sl(),
      getAllPoliciesUseCase: Injection.sl(),
      getRatesUseCase: Injection.sl(),
    ),
  );
  Injection.sl.registerFactory(
    () => PremiumRateBloc(repository: Injection.sl()),
  );
  Injection.sl.registerFactory(
    () => PremiumTermBloc(repository: Injection.sl()),
  );
  Injection.sl.registerFactory(
    () => PremiumPolicyBloc(repository: Injection.sl()),
  );
  Injection.sl.registerFactory(() => UserBloc(repository: Injection.sl()));
  Injection.sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: Injection.sl(),
      registerDeviceUseCase: Injection.sl(),
    ),
  );
}

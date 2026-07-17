import 'package:firebaseappdistribution/domain/usecase/auth/logout_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../core.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';
import '../../presentation/presentation.dart';

abstract class Injection {
  static final sl = GetIt.instance;

  static void initInjector() {
    sl.registerLazySingleton(() => NotificationService.instance);
    DAOInjection.init();
    NetworkInjeciton.init();
    RespositoryInjection.init();
    UseCaseInjection.init();
    BlocInjection.init();
  }
}

// --- DAO ---
extension DAOInjection on Injection {
  static void init() {
    Injection.sl.registerLazySingleton(() => PolicyDAO());
    Injection.sl.registerLazySingleton(() => PremiumPolicyDAO());
    Injection.sl.registerLazySingleton(() => PremiumTermDAO());
  }
}

// --- Network ---
extension NetworkInjeciton on Injection {
  static void init() {
    Injection.sl.registerLazySingleton(() => AppTalker.instance);
    Injection.sl.registerLazySingleton<Dio>(
      () => NetworkClient.getClient(ClientServiceType.protected),
    );
    Injection.sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    Injection.sl.registerLazySingleton<RemoteWipeService>(
      () => RemoteWipeServiceImpl(),
    );
  }
}

// --- Repositories ---
extension RespositoryInjection on Injection {
  static void init() {
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
    Injection.sl.registerLazySingleton<RemoteWipeRepository>(
      () => RemoteWipeRepositoryImpl(service: Injection.sl()),
    );
  }
}

// --- UseCases ---
extension UseCaseInjection on Injection {
  static void init() {
    Injection.sl.registerLazySingleton(() => LoginUseCase(Injection.sl()));
    Injection.sl.registerLazySingleton(
      () => RegisterDeviceUseCase(Injection.sl()),
    );
    Injection.sl.registerLazySingleton(() => LogoutUseCase(Injection.sl()));
    Injection.sl.registerLazySingleton(() => WipeUserUseCase(Injection.sl()));
    Injection.sl.registerLazySingleton(() => WipeAckUseCase(Injection.sl()));
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
}

// --- Blocs ---
extension BlocInjection on Injection {
  static void init() {
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
        logoutUseCase: Injection.sl(),
      ),
    );
    Injection.sl.registerFactory(
      () => RemoteWipeBloc(
        wipeUserUseCase: Injection.sl(),
        wipeAckUseCase: Injection.sl(),
      ),
    );
    Injection.sl.registerFactory(() => SplashBloc());
  }
}

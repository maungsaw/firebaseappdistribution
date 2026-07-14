import 'package:firebaseappdistribution/data/repositories/repositories.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'core/core.dart';
import 'data/data.dart';
import 'domain/domain.dart';
import 'presentation/presentation.dart';

abstract class Injection {
  static final sl = GetIt.instance;
  static void initInjector() {
    // --- ORM ---
    sl.registerLazySingleton(() => PolicyDAO());
    sl.registerLazySingleton(() => PremiumPolicyDAO());
    sl.registerLazySingleton(() => PremiumTermDAO());
    // --- Network ---
    sl.registerLazySingleton<Dio>(
      () => NetworkClient.getClient(ClientServiceType.protected),
    );
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    // --- Repositories ---
    sl.registerLazySingleton(() => RegisterDeviceUseCase(sl()));
    sl.registerLazySingleton<PolicyRepository>(
      () => PolicyRepositoryImpl(
        policyDAO: sl(),
        premiumPolicyDAO: sl(),
        premiumTermDAO: sl(),
      ),
    );
    sl.registerLazySingleton<PremiumRateRepository>(
      () => PremiumRateRepositoryImpl(),
    );
    sl.registerLazySingleton<PremiumPolicyRepository>(
      () => PremiumPolicyRepositoryImpl(),
    );
    sl.registerLazySingleton<PremiumTermRepository>(
      () => PremiumTermRepositoryImpl(),
    );
    sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(service: sl()),
    );

    // --- UseCase ---
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    // --- BLoCs ---
    sl.registerFactory(() => BottomAppbarBloc());
    sl.registerFactory(() => FilePickerBloc());
    sl.registerFactory(() => PolicyBloc(policyRepository: sl()));
    sl.registerFactory(() => PremiumRateBloc(repository: sl()));
    sl.registerFactory(() => PremiumTermBloc(repository: sl()));
    sl.registerFactory(() => PremiumPolicyBloc(repository: sl()));
    sl.registerFactory(() => UserBloc(repository: sl()));
    sl.registerFactory(
      () => AuthBloc(loginUseCase: sl(), registerDeviceUseCase: sl()),
    );
  }
}

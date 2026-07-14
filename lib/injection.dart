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
    sl.registerLazySingleton(() => PolicyORM());
    sl.registerLazySingleton(() => PremiumPolicyORM());
    sl.registerLazySingleton(() => PremiumTermORM());
    // --- Network ---
    sl.registerLazySingleton<Dio>(
      () => NetworkClient.getClient(ClientServiceType.protected),
    );
    sl.registerLazySingleton<AuthServiceImp>(() => AuthService());
    // --- Repositories ---

    sl.registerLazySingleton<WeatherRepositoryImpl>(
      () => WeatherRepository(service: sl()),
    );

    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => RegisterDeviceUseCase(sl()));
    sl.registerLazySingleton<PolicyRepositoryImpl>(
      () => PolicyRepository(
        policyORM: sl(),
        premiumPolicyORM: sl(),
        premiumTermORM: sl(),
      ),
    );
    sl.registerLazySingleton<PremiumRateRepositoryImpl>(
      () => PremiumRateRepository(),
    );
    sl.registerLazySingleton<PremiumPolicyRepositoryImpl>(
      () => PremiumPolicyRepository(),
    );
    sl.registerLazySingleton<PremiumTermRepositoryImpl>(
      () => PremiumTermRepository(),
    );
    sl.registerLazySingleton<UserRepositoryImpl>(() => UserRepository());
    sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepository(service: sl()),
    );

    // --- BLoCs ---
    sl.registerFactory(() => BottomAppbarBloc());
    sl.registerFactory(() => FilePickerBloc());
    sl.registerFactory(() => PolicyBloc(policyRepository: sl()));
    sl.registerFactory(() => WeatherBloc(weatherRepository: sl()));
    sl.registerFactory(() => PremiumRateBloc(repository: sl()));
    sl.registerFactory(() => PremiumTermBloc(repository: sl()));
    sl.registerFactory(() => PremiumPolicyBloc(repository: sl()));
    sl.registerFactory(() => UserBloc(repository: sl()));
    sl.registerFactory(
      () => AuthBloc(loginUseCase: sl(), registerDeviceUseCase: sl()),
    );
  }
}

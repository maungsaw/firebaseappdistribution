import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (!kDebugMode) {
  //   bool isDeviceSecure = await DeviceSafetyInfo.isRealDevice;
  //   debugPrint('Device is secure: $isDeviceSecure');
  //   if (!isDeviceSecure) {
  //     runApp(const CompromisedDeviceApp());
  //     return;
  //   }
  // } else {

  SystemNavigator.hideBottom();
  final options = FirebaseOptions(
    apiKey: "AIzaSyDqdwGdHUkghv8Iaydq0uG4IcGF0cYuWw",
    appId: "1:432071418438:android:588d784d19c971b92a204",
    messagingSenderId: "432071418438",
    projectId: "paypass-97314",
  );

  final instance = NotificationService.instance;

  // 2. NOW CALL INITIALIZE (Firebase is guaranteed to be ready now)
  await instance.initialize(
    options: options,
    onNavigate: (data) {
      final screen = data['screen'];
      if (screen == RouteName.calculator.path) {
        AppRouter.router.push(RouteName.calculator.path);
      }
      if (kDebugMode) {
        debugPrint('Navigating to screen: $screen with data: $data');
      }
    },
    onPermissionResult: (status) {
      if (kDebugMode) {
        debugPrint('Notification permission status: $status');
      }
    },
    backgroundMsgCallback: (data) async {
      debugPrint(
        'Handling background message with data: ${data.data}, messageId: ${data.messageId}',
      );
      // Handle background message
    },
  );
  final fcmToken = await instance.getToken();
  debugPrint('FCM Token: $fcmToken');

  runApp(const MyApp());
  // }R
}

class CompromisedDeviceApp extends StatelessWidget {
  const CompromisedDeviceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            key: const Key('compromised_screen'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.security_update_warning,
                  color: Colors.red,
                  size: 80,
                ),
                SizedBox(height: 20),
                Text(
                  'Security Violation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'This application cannot run on devices with Developer Options enabled, Root access, or Jailbreaks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomAppbarBloc()),
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => FilePickerBloc()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}

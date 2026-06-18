import 'package:device_safety_info/device_safety_info.dart';
import 'package:firebaseappdistribution/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    bool isDeviceSecure = await DeviceSafetyInfo.isRealDevice;
    debugPrint('Device is secure: $isDeviceSecure');
    if (!isDeviceSecure) {
      runApp(const CompromisedDeviceApp());
      return;
    }
  }
  runApp(const MyApp());
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
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const CounterScreen(),
      ),
    );
  }
}

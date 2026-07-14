import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../component/component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle navigation on success
        if (state is AuthLoginSuccessState) {
          context.push(RouteName.home.path);
        }

        // Handle errors (e.g., showing a Snackbar)
        if (state is AuthFailureState) {
          GlobalSnackbar.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8.0,
            children: [
              GlobalFormField(
                controller: phoneController,
                labelText: 'Phone No.',
              ),
              GlobalFormField(
                controller: passwordController,
                labelText: 'Password',
              ),
              const Spacer(),
              // Optional: Show a loading indicator if state is AuthLoading
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  return OutlinedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginSubmittedEvent(
                          mobileNumber: phoneController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

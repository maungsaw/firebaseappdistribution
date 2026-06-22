import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocSelector<BottomAppbarBloc, BottomAppbarState, int>(
        selector: (state) => state.currentIndex,
        builder: (context, index) {
          // Return the screen widget based on the index
          if (index == 1) return const DocumentScreen();
          if (index == 2) return const ProfileScreen();
          return const CounterScreen();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(2), // Shadow color
                      spreadRadius: 4, // How much the shadow expands
                      blurRadius: 10, // How blurry the shadow is
                      offset: const Offset(
                        0,
                        4,
                      ), // Shadow position changes: x (horizontal) and y (vertical)
                    ),
                  ],
                ),
                child: GlobalWidget.bottomAppbar(),
              ),
            ),
            const SizedBox(width: 15), // Spacing between nav and edit button
            FloatingActionButton(
              onPressed: () => context.push(RouteName.calculator.path),
              backgroundColor: Colors.black45,
              child: const Icon(
                Icons.calculate,
                color: Colors.lightBlue,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

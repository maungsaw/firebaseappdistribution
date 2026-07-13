import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:firebaseappdistribution/presentation/screen/setting/index.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: ScrollBottomBarListener(
          child: BlocSelector<BottomAppbarBloc, BottomAppbarState, int>(
            selector: (state) => state.currentIndex,
            builder: (context, index) {
              if (index == 1) return const ProductScreen();
              if (index == 2) return const SettingScreen();
              return const PolicyScreen();
            },
          ),
        ),
        bottomNavigationBar: BlocSelector<BottomAppbarBloc, BottomAppbarState, bool>(
          selector: (state) => state.isBottomBarVisible,
          builder: (context, isVisible) {
            return AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: isVisible ? Offset.zero : const Offset(0, 1.2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isVisible ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !isVisible,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                                  color: Colors.grey.withAlpha(2),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: GlobalWidget.bottomAppbar(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          onPressed: () => context.push(RouteName.calculator.path),
                          backgroundColor: Colors.grey[800],
                          child: const Icon(
                            Icons.calculate,
                            color: Colors.lightBlue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

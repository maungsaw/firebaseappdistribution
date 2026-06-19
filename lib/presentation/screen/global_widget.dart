import 'package:firebaseappdistribution/core/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';

abstract class GlobalWidget {
  static Widget errorView(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget loadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget bottomAppbar() {
    // Inside your Row in the BottomNavigationBar
    return BlocConsumer<BottomAppbarBloc, BottomAppbarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(RootNavigation.navigationIcons.length, (
            index,
          ) {
            // Access the index from the state
            final bool isSelected = state.currentIndex == index;

            return GestureDetector(
              onTap: () => context.read<BottomAppbarBloc>().add(
                BottomAppbarChangedEvent(index), // Pass the parameter here
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.lightBlue.withAlpha(60)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  RootNavigation.navigationIcons[index],
                  color: isSelected ? Colors.lightBlue : Colors.grey,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

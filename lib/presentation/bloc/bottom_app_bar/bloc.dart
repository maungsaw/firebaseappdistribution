import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class BottomAppbarBloc extends Bloc<BottomAppbarEvent, BottomAppbarState> {
  BottomAppbarBloc() : super(BottomAppBarInitial()) {
    on<BottomAppbarChangedEvent>((event, emit) {
      emit(
        BottomAppBarChanged(
          currentIndex: event.newIndex,
          isBottomBarVisible: true,
        ),
      );
      SystemBottomBarService.showBottom();
    });

    on<BottomBarHideEvent>((event, emit) {
      if (!state.isBottomBarVisible) return;
      emit(
        BottomAppBarChanged(
          currentIndex: state.currentIndex,
          isBottomBarVisible: false,
        ),
      );
      SystemBottomBarService.hideBottom();
    });

    on<BottomBarShowEvent>((event, emit) {
      if (state.isBottomBarVisible) return;
      emit(
        BottomAppBarChanged(
          currentIndex: state.currentIndex,
          isBottomBarVisible: true,
        ),
      );
      SystemBottomBarService.showBottom();
    });
  }
}

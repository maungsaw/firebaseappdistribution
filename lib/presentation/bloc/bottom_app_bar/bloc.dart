import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class BottomAppbarBloc extends Bloc<BottomAppbarEvent, BottomAppbarState> {
  BottomAppbarBloc() : super(BottomAppBarInitial()) {
    on<BottomAppbarChangedEvent>((event, emit) {
      emit(BottomAppBarChanged(event.newIndex));
    });
  }
}

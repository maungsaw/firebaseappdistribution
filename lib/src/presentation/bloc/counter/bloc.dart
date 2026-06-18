import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Set the initial state to 0
  CounterBloc() : super(CounterInitial()) {
    // Handle the increment event
    on<CounterIncrementPressed>((event, emit) {
      emit(CounterUpdated(state.count + 1, clickedButton: 'increment'));
    });

    // Handle the decrement event
    on<CounterDecrementPressed>((event, emit) {
      if (state.count > 0) {
        emit(CounterUpdated(state.count - 1, clickedButton: 'decrement'));
      }
    });
  }
}

sealed class CounterState {
  final int count;
  final String clickedButton;
  CounterState(this.count, {this.clickedButton = ''});
}

class CounterInitial extends CounterState {
  CounterInitial() : super(0);
}

class CounterUpdated extends CounterState {
  CounterUpdated(super.count, {super.clickedButton});
}

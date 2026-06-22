sealed class BottomAppbarEvent {}

class BottomAppbarChangedEvent extends BottomAppbarEvent {
  final int newIndex; // The parameter you want to pass
  BottomAppbarChangedEvent(this.newIndex);
}

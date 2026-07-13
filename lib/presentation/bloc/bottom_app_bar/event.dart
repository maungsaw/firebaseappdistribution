sealed class BottomAppbarEvent {}

class BottomAppbarChangedEvent extends BottomAppbarEvent {
  final int newIndex;
  BottomAppbarChangedEvent(this.newIndex);
}

class BottomBarHideEvent extends BottomAppbarEvent {}

class BottomBarShowEvent extends BottomAppbarEvent {}

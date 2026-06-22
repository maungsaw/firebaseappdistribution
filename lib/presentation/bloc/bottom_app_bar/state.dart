sealed class BottomAppbarState {
  int currentIndex;

  BottomAppbarState({this.currentIndex = 0});
}

class BottomAppBarInitial extends BottomAppbarState {
  BottomAppBarInitial() : super(currentIndex: 0);
}

class BottomAppBarChanged extends BottomAppbarState {
  BottomAppBarChanged(int index) : super(currentIndex: index);
}

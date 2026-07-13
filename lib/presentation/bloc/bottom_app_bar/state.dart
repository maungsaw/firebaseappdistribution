sealed class BottomAppbarState {
  final int currentIndex;
  final bool isBottomBarVisible;

  BottomAppbarState({
    this.currentIndex = 0,
    this.isBottomBarVisible = true,
  });
}

class BottomAppBarInitial extends BottomAppbarState {
  BottomAppBarInitial() : super();
}

class BottomAppBarChanged extends BottomAppbarState {
  BottomAppBarChanged({
    required super.currentIndex,
    super.isBottomBarVisible = true,
  });
}

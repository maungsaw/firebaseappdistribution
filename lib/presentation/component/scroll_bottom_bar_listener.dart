import 'package:firebaseappdistribution/presentation/bloc/bottom_app_bar/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollBottomBarListener extends StatelessWidget {
  const ScrollBottomBarListener({
    super.key,
    required this.child,
    this.scrollThreshold = 8,
    this.revealOffset = 48,
  });

  final Widget child;
  final double scrollThreshold;
  final double revealOffset;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;

        final bloc = context.read<BottomAppbarBloc>();
        final isVisible = bloc.state.isBottomBarVisible;

        if (notification is ScrollUpdateNotification) {
          final delta = notification.scrollDelta ?? 0;

          if (delta > scrollThreshold &&
              notification.metrics.pixels > revealOffset &&
              isVisible) {
            bloc.add(BottomBarHideEvent());
          } else if (delta < -scrollThreshold && !isVisible) {
            bloc.add(BottomBarShowEvent());
          }
        }

        if (notification.metrics.pixels <= 0 && !isVisible) {
          bloc.add(BottomBarShowEvent());
        }

        return false;
      },
      child: child,
    );
  }
}

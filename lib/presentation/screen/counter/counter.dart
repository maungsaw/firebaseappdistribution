import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Container(
            padding: .all(6),
            margin: .all(8),
            decoration: BoxDecoration(
              borderRadius: .all(Radius.circular(10)),
              color: Colors.lightBlue.withAlpha(60),
            ),
            child: Row(
              crossAxisAlignment: .center,
              mainAxisAlignment: .spaceAround,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.lightGreen,
                  child: IconButton(
                    onPressed: () => context.read<CounterBloc>().add(
                      CounterIncrementPressed(),
                    ),
                    icon: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
                Text(
                  '${state.count}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 100.0,
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    onPressed: () => context.read<CounterBloc>().add(
                      CounterDecrementPressed(),
                    ),
                    icon: Icon(Icons.remove, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        buildWhen: (previous, current) {
          debugPrint(
            'buildWhen called: previous=${previous.count}, current=${current.count}',
          );
          final result = previous.count != current.count;
          return result;
        },
      ),
    );
  }
}

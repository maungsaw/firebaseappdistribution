import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure this is wrapped in a BlocProvider as shown in the previous response
    return BlocConsumer<PolicyBloc, PolicyState>(
      // Use listenWhen to control when the listener should run
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        debugPrint("Listener - Current State: $state");
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is LoadingPolicyState) return GlobalWidget.loadingView();
        if (state is InitialPolicyState) {
          context.watch<PolicyBloc>().add(SuccessPolicyEvent());
          return GlobalWidget.loadingView();
        }
        if (state is SuccessPolicyState) {
          return Center(
            child: Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .spaceAround,
              children: [
                Text('${state.data}', style: TextStyle(fontSize: 45)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => context.read<PolicyBloc>().add(
                    NewPolicyEvent('P-2', 'DRAFT'),
                  ),
                  child: Text('Create'),
                ),
              ],
            ),
          );
        }
        // Safe access to state.message (ensure it exists in your base State class)
        return GlobalWidget.errorView(state.message);
      },
    );
  }
}

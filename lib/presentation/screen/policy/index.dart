import 'package:firebaseappdistribution/core/core.dart'
    show AppRoutes, PolicyStatus;
import 'package:firebaseappdistribution/data/data.dart' show PolicyModel;
import 'package:firebaseappdistribution/presentation/presentation.dart'
    show
        PolicyBloc,
        PolicyState,
        LoadingPolicyState,
        GlobalWidget,
        InitialPolicyState,
        FetchPolicyState,
        SuccessPolicyEvent,
        RemovePolicyEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure this is wrapped in a BlocProvider as shown in the previous response
    return BlocConsumer<PolicyBloc, PolicyState>(
      // Use listenWhen to control when the listener should run
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {},
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is LoadingPolicyState) return GlobalWidget.loadingView();
        if (state is InitialPolicyState) {
          context.watch<PolicyBloc>().add(SuccessPolicyEvent());
          return GlobalWidget.loadingView();
        }
        if (state is FetchPolicyState) {
          return Center(
            child: state.data.isEmpty
                ? btnCreate(context, state.data.length)
                : Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.data.length,
                        itemBuilder: (context, index) =>
                            policyItem(state.data[index], context),
                      ),
                      Align(
                        alignment: .bottomCenter,
                        child: btnCreate(context, state.data.length),
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

  Widget btnCreate(BuildContext context, int length) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        onPressed: () => context.push('${AppRoutes.policy}/create'),
        label: Text("Create"),
      ),
    );
  }

  Widget policyItem(PolicyModel policy, BuildContext context) {
    return ListTile(
      onTap: () => context.push('${AppRoutes.policy}/detail', extra: policy),
      title: Text(policy.no),
      subtitle: Container(
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: policy.status == PolicyStatus.draft.label
              ? Colors.red
              : policy.status == PolicyStatus.pending.label
              ? Colors.orangeAccent
              : Colors.green,
        ),
        child: Padding(
          padding: const .symmetric(vertical: 1.0, horizontal: 2.0),
          child: Text(policy.status, style: TextStyle(color: Colors.white)),
        ),
      ),

      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () =>
                context.push('${AppRoutes.policy}/edit', extra: policy),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () =>
                context.read<PolicyBloc>().add(RemovePolicyEvent(policy.id!)),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

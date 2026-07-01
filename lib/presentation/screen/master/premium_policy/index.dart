import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PremiumPolicyScreen extends StatelessWidget {
  const PremiumPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Policy')),
      body: BlocConsumer<PremiumPolicyBloc, PremiumPolicyState>(
        listenWhen: (previous, current) => previous != current,
        buildWhen: (previous, current) => previous != current,
        listener: (context, PremiumPolicyState state) {
          debugPrint("State here -> $state");
          if (state is FailurePremiumPolicyState) {
            return GlobalSnackbar.showError(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is LoadingPremiumPolicyState) {
            return GlobalWidget.loadingView();
          }
          if (state is InitialPremiumPolicyState) {
            context.watch<PremiumPolicyBloc>().add(FetchedPremiumPolicyEvent());
            return GlobalWidget.loadingView();
          }
          if (state is SuccessPremiumPolicyState) {
            return GlobalReorderableList(
              items: state.data,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                final updatedList = List<PremiumPolicyModel>.from(state.data);
                final movedItem = updatedList.removeAt(oldIndex);
                updatedList.insert(newIndex, movedItem);
                context.read<PremiumPolicyBloc>().add(
                  ReorderPremiumPolicyEvent(updatedList: updatedList),
                );
              },
              leadingIcon: Icons.description_rounded,
              onDelete: (item) {
                context.read<PremiumPolicyBloc>().add(
                  DeletePremiumPolicyEvent(id: item.id),
                );
              },
              onEdit: (item) => context.push(
                '${RouteName.premiumPolicy.path}/edit',
                extra: item,
              ),
              onView: (item) => context.push(
                '${RouteName.premiumPolicy.path}/detail',
                extra: item,
              ),
            );
          }
          return Text(state.message);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("${RouteName.premiumPolicy.path}/create"),
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PremiumTermScreen extends StatelessWidget {
  const PremiumTermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Term')),
      body: BlocConsumer<PremiumTermBloc, PremiumTermState>(
        listenWhen: (previous, current) => previous != current,
        buildWhen: (previous, current) => previous != current,
        listener: (context, PremiumTermState state) {
          if (state is FailurePremiumTermState) {
            return GlobalSnackbar.showError(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is LoadingPremiumTermState) {
            return GlobalWidget.loadingView();
          }
          if (state is InitialPremiumTermState) {
            context.watch<PremiumTermBloc>().add(FetchedPremiumTermEvent());
            return GlobalWidget.loadingView();
          }
          if (state is SuccessPremiumTermState) {
            return GlobalReorderableList(
              items: state.data,
              leadingIcon: Icons.access_time_rounded,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;

                final updatedList = List<PremiumTermModel>.from(state.data);
                final movedItem = updatedList.removeAt(oldIndex);
                updatedList.insert(newIndex, movedItem);

                context.read<PremiumTermBloc>().add(
                  ReorderPremiumTermEvent(updatedList: updatedList),
                );
              },
              onDelete: (item) {
                context.read<PremiumTermBloc>().add(
                  DeletePremiumTermEvent(id: item.id),
                );
              },
              onEdit: (item) => context.push(
                '${RouteName.premiumTerm.path}/edit',
                extra: item,
              ),
              onView: (item) => context.push(
                '${RouteName.premiumTerm.path}/detail',
                extra: item,
              ),
            );
          }
          return Text(state.message);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("${RouteName.premiumTerm.path}/create"),
        child: Icon(Icons.add),
      ),
    );
  }
}

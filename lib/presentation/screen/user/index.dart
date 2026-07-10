import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserBloc>().add(FetchedUserEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User')),
      body: BlocConsumer<UserBloc, UserState>(
        listenWhen: (previous, current) => previous != current,
        buildWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is FailureUserState) {
            GlobalSnackbar.showError(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is LoadingUserState || state is InitialUserState) {
            return GlobalWidget.loadingView();
          }

          if (state is SuccessUserState) {
            if (state.users.isEmpty) {
              return Center(
                child: Text(
                  'No users found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card.filled(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(user.phone),
                        Text(user.nrc),
                        Text(
                          user.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push(
                      '${RouteName.user.path}/detail',
                      extra: user,
                    ),
                  ),
                );
              },
            );
          }
          return Text(state.message);
        },
      ),
    );
  }
}

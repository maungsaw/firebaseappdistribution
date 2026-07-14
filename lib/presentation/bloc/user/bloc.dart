import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(InitialUserState()) {
    on<FetchedUserEvent>(fetch);
  }

  Future<void> fetch(FetchedUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final result = await repository.getAllUsers();
      emit(SuccessUserState(users: result));
    } catch (e) {
      debugPrint('UserBloc fetch error -> $e');
      emit(FailureUserState(errorMessage: e.toString()));
    }
  }
}

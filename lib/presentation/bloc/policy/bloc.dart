import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  PolicyBloc() : super(InitialPolicyState()) {
    on((SuccessPolicyEvent event, emit) async => await fetch(event, emit));
    add(SuccessPolicyEvent());
  }
  Future<void> fetch(
    SuccessPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      emit(LoadingPolicyState());
      final count = await DatabaseManager.instance.getPolicyCount();
      debugPrint("Hello -> $count");
      emit(SuccessPolicyState(count));
    } catch (cryptoError) {
      emit(
        ErrorPolicyState(
          'Cryptographic processing failed. Ensure the file is valid and try again.',
        ),
      );
    }
  }
}

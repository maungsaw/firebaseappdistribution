import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class PremiumPolicyBloc extends Bloc<PremiumPolicyEvent, PremiumPolicyState> {
  final PremiumPolicyRepository repository;
  PremiumPolicyBloc({required this.repository})
    : super(InitialPremiumPolicyState()) {
    on<FetchedPremiumPolicyEvent>(fetch);
    on<CreatePremiumPolicyEvent>(create);
    on<UpdatePremiumPolicyEvent>(update);
    on<DeletePremiumPolicyEvent>(delete);
  }

  Future<void> fetch(
    FetchedPremiumPolicyEvent event,
    Emitter<PremiumPolicyState> emit,
  ) async {
    try {
      debugPrint("HELLO");
      emit(LoadingPremiumPolicyState());
      final result = await fetchAll();
      emit(SuccessPremiumPolicyState(premiumPolicys: result));
    } catch (e) {
      emit(FailurePremiumPolicyState(errorMessage: e.toString()));
    }
  }

  Future<List<PremiumPolicyModel>> fetchAll() async {
    return await repository.getAllTerms();
  }

  Future<void> create(
    CreatePremiumPolicyEvent event,
    Emitter<PremiumPolicyState> emit,
  ) async {
    emit(LoadingPremiumPolicyState());
    final result = await repository.createTerm(event.premiumPolicyModel);
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumPolicyState(premiumPolicys: result));
    } else {
      emit(FailurePremiumPolicyState(errorMessage: 'Something Wrong'));
    }
  }

  Future<void> update(
    UpdatePremiumPolicyEvent event,
    Emitter<PremiumPolicyState> emit,
  ) async {
    emit(LoadingPremiumPolicyState());
    final result = await repository.updateTerm(
      event.premiumPolicyModel,
      event.id,
    );
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumPolicyState(premiumPolicys: result));
    } else {
      emit(FailurePremiumPolicyState(errorMessage: 'Something Wrong'));
    }
  }

  Future<void> delete(
    DeletePremiumPolicyEvent event,
    Emitter<PremiumPolicyState> emit,
  ) async {
    emit(LoadingPremiumPolicyState());
    final result = await repository.deleteTerm(event.id);
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumPolicyState(premiumPolicys: result));
    } else {
      emit(FailurePremiumPolicyState(errorMessage: 'Something Wrong'));
    }
  }
}

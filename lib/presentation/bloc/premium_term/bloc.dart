import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class PremiumTermBloc extends Bloc<PremiumTermEvent, PremiumTermState> {
  final PremiumTermRepository repository;
  PremiumTermBloc({required this.repository})
    : super(InitialPremiumTermState()) {
    on<FetchedPremiumTermEvent>(fetch);
    on<CreatePremiumTermEvent>(create);
    on<UpdatePremiumTermEvent>(update);
    on<DeletePremiumTermEvent>(delete);
  }

  Future<void> fetch(
    FetchedPremiumTermEvent event,
    Emitter<PremiumTermState> emit,
  ) async {
    try {
      debugPrint("HELLO");
      emit(LoadingPremiumTermState());
      final result = await fetchAll();
      emit(SuccessPremiumTermState(premiumTerms: result));
    } catch (e) {
      emit(FailurePremiumTermState(errorMessage: e.toString()));
    }
  }

  Future<List<PremiumTermModel>> fetchAll() async {
    return await repository.getAllTerms();
  }

  Future<void> create(
    CreatePremiumTermEvent event,
    Emitter<PremiumTermState> emit,
  ) async {
    emit(LoadingPremiumTermState());
    final result = await repository.createTerm(event.premiumTermModel);
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumTermState(premiumTerms: result));
    } else {
      emit(FailurePremiumTermState(errorMessage: 'Something Wrong'));
    }
  }

  Future<void> update(
    UpdatePremiumTermEvent event,
    Emitter<PremiumTermState> emit,
  ) async {
    emit(LoadingPremiumTermState());
    final result = await repository.updateTerm(
      event.premiumTermModel,
      event.id,
    );
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumTermState(premiumTerms: result));
    } else {
      emit(FailurePremiumTermState(errorMessage: 'Something Wrong'));
    }
  }

  Future<void> delete(
    DeletePremiumTermEvent event,
    Emitter<PremiumTermState> emit,
  ) async {
    emit(LoadingPremiumTermState());
    final result = await repository.deleteTerm(event.id);
    if (result > -1) {
      final result = await fetchAll();
      emit(SuccessPremiumTermState(premiumTerms: result));
    } else {
      emit(FailurePremiumTermState(errorMessage: 'Something Wrong'));
    }
  }
}

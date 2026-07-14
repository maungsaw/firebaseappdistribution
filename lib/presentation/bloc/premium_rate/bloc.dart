import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class PremiumRateBloc extends Bloc<PremiumRateEvent, PremiumRateState> {
  final PremiumRateRepository repository;
  PremiumRateBloc({required this.repository})
    : super(InitialPremiumRateState()) {
    on<ImportedPremiumRateEvent>((event, emit) async {
      await importExcel(event, emit);
    });
  }

  Future<void> importExcel(
    ImportedPremiumRateEvent event,
    Emitter<PremiumRateState> emit,
  ) async {
    emit(LoadingPremiumRateState());
    try {
      final premiumRates = await ExcelReader.readPremiumRate(
        path: event.path,
        columns: ['FromAge', 'ToAge', 'Gender', 'PremiumTerm', 'Premium Rate'],
        sheets: ['Male', 'Female'],
        fromMap: (map) => PremiumRateModel.fromMap(map),
      );
      final result = await repository.createAll(premiumRates);
      if (result > -1) {
        emit(SuccessPremiumRateState(successCount: result));
      } else {
        emit(FailurePremiumRateState(errorMessage: "Can't insert"));
      }
    } catch (e) {
      debugPrint('Error bloc -> $e');
    }
  }
}

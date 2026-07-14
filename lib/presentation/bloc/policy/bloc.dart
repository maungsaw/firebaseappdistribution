import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  // Inject UseCases instead of Repository
  final CreatePolicyUseCase createPolicyUseCase;
  final RemovePolicyUseCase removePolicyUseCase;
  final UpdatePolicyUseCase updatePolicyUseCase;
  final GetAllPoliciesUseCase getAllPoliciesUseCase;
  final GetRatesUseCase getRatesUseCase;

  PolicyBloc({
    required this.createPolicyUseCase,
    required this.removePolicyUseCase,
    required this.updatePolicyUseCase,
    required this.getAllPoliciesUseCase,
    required this.getRatesUseCase,
  }) : super(InitialPolicyState()) {
    on<SuccessPolicyEvent>(_onFetchPolicy);
    on<NewPolicyEvent>(_onCreatePolicy);
    on<RemovePolicyEvent>(_removePolicy);
    on<UpdatePolicyEvent>(_onUpdatePolicy);
    on<LoadPremiumOptionsEvent>(_onLoadPremiumOptions);
  }

  Future<void> _onFetchPolicy(
    SuccessPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    emit(LoadingPolicyState());
    try {
      final data = await getAllPoliciesUseCase();
      emit(FetchPolicyState(data));
    } catch (e) {
      emit(ErrorPolicyState('Failed to fetch policies: ${e.toString()}'));
    }
  }

  Future<void> _removePolicy(
    RemovePolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    emit(LoadingPolicyState());
    try {
      final count = await removePolicyUseCase(event.id);
      if (count > -1) {
        final data = await getAllPoliciesUseCase();
        emit(FetchPolicyState(data));
      }
    } catch (e) {
      emit(ErrorPolicyState('Failed to remove policy: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePolicy(
    NewPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    emit(LoadingPolicyState());
    try {
      final count = await createPolicyUseCase(event.policyModel);
      if (count > -1) {
        emit(SuccessPolicyState());
        final data = await getAllPoliciesUseCase();
        emit(FetchPolicyState(data));
      }
    } catch (e) {
      emit(ErrorPolicyState('Failed to create policy: ${e.toString()}'));
    }
  }

  Future<void> _onUpdatePolicy(
    UpdatePolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    emit(LoadingPolicyState());
    try {
      final count = await updatePolicyUseCase(event.policy);
      if (count > -1) {
        emit(SuccessPolicyState());
        final data = await getAllPoliciesUseCase();
        emit(FetchPolicyState(data));
      }
    } catch (e) {
      emit(ErrorPolicyState('Failed to update policy: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPremiumOptions(
    LoadPremiumOptionsEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      final rate = await getRatesUseCase(event.age, event.term, event.gender);
      emit(PremiumOptionsLoadedState(rate: rate));
    } catch (e) {
      emit(ErrorPolicyState(e.toString()));
    }
  }
}

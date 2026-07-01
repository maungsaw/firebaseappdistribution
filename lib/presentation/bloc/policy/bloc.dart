import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  final PolicyRepositoryImpl policyRepository;

  PolicyBloc({required this.policyRepository}) : super(InitialPolicyState()) {
    // Corrected syntax for event handlers
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
    try {
      emit(LoadingPolicyState());
      final data = await getAll();
      emit(FetchPolicyState(data));
    } catch (e) {
      emit(ErrorPolicyState('Failed to fetch policies: ${e.toString()}'));
    }
  }

  Future<void> _removePolicy(
    RemovePolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      emit(LoadingPolicyState());
      final count = await policyRepository.removePolicy(event.id);
      if (count > -1) {
        final data = await getAll();
        emit(FetchPolicyState(data));
      }
    } catch (e) {
      emit(ErrorPolicyState('Failed to fetch policies: ${e.toString()}'));
    }
  }

  Future<List<PolicyModel>> getAll() async {
    return await policyRepository.getAll();
  }

  Future<void> _onCreatePolicy(
    NewPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      emit(LoadingPolicyState());

      final count = await policyRepository.createPolicy(event.policyModel);

      if (count > -1) {
        emit(SuccessPolicyState());
        final data = await getAll();
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
    try {
      emit(LoadingPolicyState());
      final count = await policyRepository.updatePolicy(event.policy);

      if (count > -1) {
        emit(SuccessPolicyState());
        final data = await getAll();
        emit(FetchPolicyState(data));
      }
    } catch (e) {
      emit(ErrorPolicyState('Failed to create policy: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPremiumOptions(
    LoadPremiumOptionsEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      // Fetch dynamic options concurrently from your local DB layer using the age parameter
      // final terms = await repository.getPremiumTermsByAge(event.age);
      // final policies = await repository.getPremiumPoliciesByAge(event.age);

      // Emit the state containing data arrays so the UI state listeners can capture it
      //  emit(PremiumOptionsLoadedState(terms: terms, policies: policies));
    } catch (error) {
      // Handle fallback or error states gracefully if query execution fails
      emit(ErrorPolicyState(error.toString()));
    }
  }
}

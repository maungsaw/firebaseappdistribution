import 'package:firebaseappdistribution/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  // Inject the repository via the constructor
  final PolicyRepositoryImpl policyRepository;

  PolicyBloc({required this.policyRepository}) : super(InitialPolicyState()) {
    // Corrected syntax for event handlers
    on<SuccessPolicyEvent>(_onFetchPolicy);
    on<NewPolicyEvent>(_onCreatePolicy);
  }

  Future<void> _onFetchPolicy(
    SuccessPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      emit(LoadingPolicyState());
      final count = await policyRepository.getAll();
      emit(SuccessPolicyState(count));
    } catch (e) {
      emit(ErrorPolicyState('Failed to fetch policies: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePolicy(
    NewPolicyEvent event,
    Emitter<PolicyState> emit,
  ) async {
    try {
      emit(LoadingPolicyState());
      // Assuming createPolicy accepts the parameters from the event
      final count = await policyRepository.createPolicy(event.no, event.status);
      emit(SuccessPolicyState(count));
    } catch (e) {
      emit(ErrorPolicyState('Failed to create policy: ${e.toString()}'));
    }
  }
}

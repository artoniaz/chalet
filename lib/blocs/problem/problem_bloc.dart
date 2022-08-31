import 'package:Challet/blocs/problem/problem_event.dart';
import 'package:Challet/blocs/problem/problem_state.dart';
import 'package:Challet/repositories/problem_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProblemBloc extends Bloc<ProblemEvent, ProblemState> {
  final ProblemRepository problemRepository;
  ProblemBloc({required this.problemRepository}) : super(ProblemStateInitial());

  ProblemState get initialState => ProblemStateInitial();

  @override
  void onTransition(Transition<ProblemEvent, ProblemState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ProblemState> mapEventToState(ProblemEvent event) async* {
    if (event is CreateProblem) {
      yield* _handleCreateProblem(event);
    }
  }

  Stream<ProblemState> _handleCreateProblem(CreateProblem event) async* {
    yield ProblemStateLoading();
    try {
      await problemRepository.createProblem(event.problem);
      yield ProblemStateLoaded();
    } catch (e) {
      yield ProblemStateError('Nie udało się zgłosić problemu.');
    }
  }
}

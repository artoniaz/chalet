import 'package:chalet/blocs/create_team/create_team_event.dart';
import 'package:chalet/blocs/create_team/create_team_state.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTeamBloc extends Bloc<CreateTeamEvent, CreateTeamState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  CreateTeamBloc({
    required this.teamRepository,
    required this.userDataRepository,
  }) : super(CreateTeamStateInitial());

  CreateTeamState get initialState => CreateTeamStateInitial();

  @override
  void onTransition(Transition<CreateTeamEvent, CreateTeamState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<CreateTeamState> mapEventToState(CreateTeamEvent event) async* {
    if (event is AddCreateTeamEvent) yield* _handleCreateTeamEvent(event);
    if (event is ResetCreateTeamBloc) {
      yield* _handleResetTeamBloc(event);
    }
  }

  Stream<CreateTeamState> _handleCreateTeamEvent(AddCreateTeamEvent event) async* {
    yield CreateTeamStateLoading();
    try {
      String teamId = await teamRepository.createTeam(
        event.userId,
        event.userName,
        event.teamName,
        event.color,
      );
      yield CreateTeamStateTeamCreated();
      await userDataRepository.updateUserTeamData(event.userId, teamId, event.color);
    } catch (e) {
      yield CreateTeamStateError(e.toString());
    }
  }

  Stream<CreateTeamState> _handleResetTeamBloc(ResetCreateTeamBloc event) async* {
    yield CreateTeamStateInitial();
  }
}

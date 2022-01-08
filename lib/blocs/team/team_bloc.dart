import 'package:chalet/blocs/team/team_event.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  TeamBloc({
    required this.teamRepository,
    required this.userDataRepository,
  }) : super(TeamStateInitial());

  TeamState get initialState => TeamStateInitial();

  @override
  void onTransition(Transition<TeamEvent, TeamState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    if (event is AddTeamEvent) yield* _handleAddTeamEvent(event);
    if (event is ResetTeamBloc) {
      yield* _handleResetTeamBloc(event);
    }
  }

  Stream<TeamState> _handleAddTeamEvent(AddTeamEvent event) async* {
    yield TeamStateLoading();
    try {
      String teamId = await teamRepository.createTeam(event.userId, event.userName, event.teamName);
      await userDataRepository.updateUserTeamData(event.userId, teamId, event.teamName);
      yield TeamStateTeamCreated();
    } catch (e) {
      yield TeamStateError(e.toString());
    }
  }

  Stream<TeamState> _handleResetTeamBloc(ResetTeamBloc event) async* {
    yield TeamStateInitial();
  }
}

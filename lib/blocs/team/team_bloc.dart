import 'package:chalet/blocs/team/team_event.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/models/team_model.dart';
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

  TeamModel get team => this.state.props.first as TeamModel;

  TeamState get initialState => TeamStateInitial();

  @override
  void onTransition(Transition<TeamEvent, TeamState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    if (event is ResetTeamBloc) {
      yield* _handleResetTeamBloc(event);
    }
    if (event is GetTeamEvent) {
      yield* _handleGetTeamEvent(event);
    }
    if (event is UpdateTeamStats) {
      yield* _handleUpdateTeamStatsEvent(event);
    }
  }

  Stream<TeamState> _handleGetTeamEvent(GetTeamEvent event) async* {
    yield TeamStateLoading();
    try {
      TeamModel team = await teamRepository.getTeam(event.teamId);
      yield TeamStateTeamLoaded(team: team);
    } catch (e) {
      yield TeamStateError(e.toString());
    }
  }

  Stream<TeamState> _handleUpdateTeamStatsEvent(UpdateTeamStats event) async* {
    yield TeamStateLoading();
    try {
      TeamModel teamModel = team;
      teamModel.chaletAddedNumber = event.chaletAddedNumber;
      teamModel.chaletReviewsNumber = event.chaletReviewsNumber;
      yield TeamStateTeamLoaded(team: teamModel);
    } catch (e) {
      yield TeamStateError(e.toString());
    }
  }

  Stream<TeamState> _handleResetTeamBloc(ResetTeamBloc event) async* {
    yield TeamStateInitial();
  }
}

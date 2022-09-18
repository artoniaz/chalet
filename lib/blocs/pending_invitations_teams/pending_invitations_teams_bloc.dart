import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_event.dart';
import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_state.dart';
import 'package:chalet/models/team_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingInvitationsTeamsBloc extends Bloc<PendingInvitationsTeamEvent, PendingInvitationsTeamsState> {
  final TeamRepository teamRepository;
  PendingInvitationsTeamsBloc({
    required this.teamRepository,
  }) : super(PendingInvitationsTeamsStateInitial());

  PendingInvitationsTeamsStateInitial get initialState => PendingInvitationsTeamsStateInitial();

  @override
  void onTransition(Transition<PendingInvitationsTeamEvent, PendingInvitationsTeamsState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<PendingInvitationsTeamsState> mapEventToState(PendingInvitationsTeamEvent event) async* {
    if (event is GetPendingInvitationsTeams) {
      yield* _handleGetTeamForPendingInvitationsEvent(event);
    }
    if (event is ResetPendingInvitationsTeam) {
      yield* _handleResetPendingInvitationsTeam(event);
    }
  }

  Stream<PendingInvitationsTeamsState> _handleGetTeamForPendingInvitationsEvent(
      GetPendingInvitationsTeams event) async* {
    yield PendingInvitationsTeamsStateLoading();
    try {
      List<Future<TeamModel>> futures = [];
      event.teamIds.forEach((String teamId) async {
        futures.add(teamRepository.getTeam(teamId));
      });

      List<TeamModel> teams = await Future.wait(futures);
      yield PendingInvitationsTeamsStateLoaded(pendingInvitationsTeamList: teams);
    } catch (e) {
      yield PendingInvitationsTeamsStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<PendingInvitationsTeamsState> _handleResetPendingInvitationsTeam(ResetPendingInvitationsTeam event) async* {
    yield PendingInvitationsTeamsStateInitial();
  }
}

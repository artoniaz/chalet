import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_event.dart';
import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_state.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/screens/authenticate/register.dart';
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
    if (event is GetPendingInvitationsTeamMembers) {
      yield* _handleGetTeamMembersForPendingInvitationsEvent(event);
    }
    if (event is ResetPendingInvitationsTeamMembers) {
      yield* _handleResetPendingInvitationsTeamMembers(event);
    }
  }

  Stream<PendingInvitationsTeamsState> _handleGetTeamMembersForPendingInvitationsEvent(
      GetPendingInvitationsTeamMembers event) async* {
    yield PendingInvitationsTeamsStateLoading();
    try {
      List<Future<List<TeamMemberModel>>> futures = [];
      event.teamIds.forEach((String teamId) async {
        futures.add(teamRepository.getTeamMemberList(teamId));
      });
      List<List<TeamMemberModel>> teams = await Future.wait(futures);
      yield PendingInvitationsTeamsStateLoaded(pendingInvitationsTeamsMemberList: teams);
    } catch (e) {
      yield PendingInvitationsTeamsStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<PendingInvitationsTeamsState> _handleResetPendingInvitationsTeamMembers(
      ResetPendingInvitationsTeamMembers event) async* {
    yield PendingInvitationsTeamsStateInitial();
  }
}

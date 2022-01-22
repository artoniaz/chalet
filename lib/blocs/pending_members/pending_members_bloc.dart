import 'package:chalet/blocs/pending_members/pending_members_event.dart';
import 'package:chalet/blocs/pending_members/pending_members_state.dart';
import 'package:chalet/blocs/team/team_event.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/blocs/team_member/team_member_event.dart';
import 'package:chalet/blocs/team_member/team_member_state.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingTeamMembersBloc extends Bloc<PendingTeamMembersEvent, PendingTeamMembersState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  PendingTeamMembersBloc({
    required this.teamRepository,
    required this.userDataRepository,
  }) : super(PendingTeamMembersStateInitial());

  List<TeamMemberModel> _pendingTeamMembers = [];
  List<TeamMemberModel> get pendingTeamMembers => _pendingTeamMembers;

  TeamMemberState get initialState => TeamMemberStateInitial();

  @override
  void onTransition(Transition<PendingTeamMembersEvent, PendingTeamMembersState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<PendingTeamMembersState> mapEventToState(PendingTeamMembersEvent event) async* {
    if (event is InviteTeamMember) {
      yield* _handleInviteTeamMemberEvent(event);
    }
    if (event is GetPendingMembers) {
      yield* _handleGetPendingTeamListEvent(event);
    }
    if (event is ResetPendingTeamMembersBloc) {
      yield* _handleResetPendingTeamMemberBloc(event);
    }
  }

  Stream<PendingTeamMembersState> _handleGetPendingTeamListEvent(GetPendingMembers event) async* {
    yield PendingTeamMembersStateLoading();
    try {
      List<TeamMemberModel> pendingMembers = await teamRepository.getPendingTeamMemberList(event.teamId);
      _pendingTeamMembers.clear();
      _pendingTeamMembers.addAll(pendingMembers);
      yield PendingTeamMemberListLoaded(pendingTeamMemberList: pendingMembers);
    } catch (e) {
      yield PendingTeamMembersStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<PendingTeamMembersState> _handleInviteTeamMemberEvent(InviteTeamMember event) async* {
    yield PendingTeamMembersStateLoading();
    try {
      Future _createPendingTeamMember() => teamRepository.createPendingTeamMember(event.teamMemberModel);
      Future _addUserInvitationToTeam() =>
          userDataRepository.addUserInvitationToTeam(event.teamMemberModel.id, event.teamMemberModel.teamId);
      var futures = [
        _createPendingTeamMember(),
        _addUserInvitationToTeam(),
      ];
      await Future.wait(futures);
      yield PendingTeamMembersStateInvited();
      this.add(GetPendingMembers(event.teamMemberModel.teamId));
    } catch (e) {
      yield PendingTeamMembersStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<PendingTeamMembersState> _handleResetPendingTeamMemberBloc(ResetPendingTeamMembersBloc event) async* {
    yield PendingTeamMembersStateInitial();
  }
}

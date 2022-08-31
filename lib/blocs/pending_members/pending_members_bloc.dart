import 'package:Challet/blocs/pending_members/pending_members_event.dart';
import 'package:Challet/blocs/pending_members/pending_members_state.dart';
import 'package:Challet/blocs/team_member/team_member_state.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/repositories/team_repository.dart';
import 'package:Challet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingTeamMembersBloc extends Bloc<PendingTeamMembersEvent, PendingTeamMembersState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  PendingTeamMembersBloc({
    required this.teamRepository,
    required this.userDataRepository,
  }) : super(PendingTeamMembersStateInitial());

  List<UserModel> _pendingTeamMembers = [];
  List<UserModel> get pendingTeamMembers => _pendingTeamMembers;

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
    if (event is GetPendingTeamMembers) {
      yield* _handleGetPendingTeamListEvent(event);
    }
    if (event is ResetPendingTeamMembersBloc) {
      yield* _handleResetPendingTeamMemberBloc(event);
    }
  }

  Stream<PendingTeamMembersState> _handleGetPendingTeamListEvent(GetPendingTeamMembers event) async* {
    yield PendingTeamMembersStateLoading();
    try {
      List<String> pendingMembersIds = event.team.pendingMembersIds ?? [];
      if (event.newPendingUserId != null) pendingMembersIds.add(event.newPendingUserId!);
      List<UserModel> pendingMembers = await teamRepository.getPendingTeamMembers(pendingMembersIds);
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
      Future _createPendingTeamMember() => teamRepository.createPendingTeamMember(event.team.id, event.pendingMemberId);
      Future _addUserInvitationToTeam() =>
          userDataRepository.addUserInvitationToTeam(event.pendingMemberId, event.team.id);
      var futures = [
        _createPendingTeamMember(),
        _addUserInvitationToTeam(),
      ];
      await Future.wait(futures);
      yield PendingTeamMembersStateInvited();
      this.add(GetPendingTeamMembers(event.team, event.pendingMemberId));
    } catch (e) {
      yield PendingTeamMembersStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<PendingTeamMembersState> _handleResetPendingTeamMemberBloc(ResetPendingTeamMembersBloc event) async* {
    yield PendingTeamMembersStateInitial();
  }
}

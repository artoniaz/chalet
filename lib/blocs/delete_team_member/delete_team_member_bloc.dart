import 'package:chalet/blocs/delete_team_member/delete_team_member_event.dart';
import 'package:chalet/blocs/delete_team_member/delete_team_member_state.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/team_members/team_members_state.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class DeleteTeamMemberBloc extends Bloc<DeleteTeamMemberEvent, DeleteTeamMemberState> {
  final TeamRepository teamRepository;
  final TeamMembersBloc teamMembersBloc;
  final UserDataRepository userDataRepository;
  DeleteTeamMemberBloc({
    required this.teamRepository,
    required this.teamMembersBloc,
    required this.userDataRepository,
  }) : super(DeleteTeamMemberStateInitial());

  TeamMembersState get initialState => TeamMembersStateInitial();

  @override
  void onTransition(Transition<DeleteTeamMemberEvent, DeleteTeamMemberState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<DeleteTeamMemberState> mapEventToState(DeleteTeamMemberEvent event) async* {
    if (event is DeleteTeamMember) {
      yield* _handleDeleteTeamMembersEvent(event);
    }
  }

  Stream<DeleteTeamMemberState> _handleDeleteTeamMembersEvent(DeleteTeamMember event) async* {
    yield DeleteTeamMemberStateLoading();
    try {
      await teamRepository.deleteTeamMember(event.team.id, event.userToDeleteId, event.choosenColor);
      yield DeleteTeamMemberStateDeleted();
      List<String> teamMembersIds = event.team.membersIds ?? [];
      teamMembersIds.remove(event.userToDeleteId);
      teamMembersBloc.add(GetTeamMembers(teamMembersIds, event.adminUser));

      userDataRepository.updateUserTeamData(event.userToDeleteId, '');
    } catch (e) {
      yield DeleteTeamMemberStateError(e.toString());
      print(e.toString());
    }
  }
}

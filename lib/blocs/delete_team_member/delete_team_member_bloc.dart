import 'package:chalet/blocs/delete_team_member/delete_team_member_event.dart';
import 'package:chalet/blocs/delete_team_member/delete_team_member_state.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/team_members/team_members_state.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class DeleteTeamMemberBloc extends Bloc<DeleteTeamMemberEvent, DeleteTeamMemberState> {
  final TeamRepository teamRepository;
  final TeamMembersBloc teamMembersBloc;
  DeleteTeamMemberBloc({
    required this.teamRepository,
    required this.teamMembersBloc,
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
      await teamRepository.deleteTeamMember(event.userToDeleteId, event.teamId);
      yield DeleteTeamMemberStateDeleted();
      teamMembersBloc.add(GetTeamMembers(event.teamId));
    } catch (e) {
      yield DeleteTeamMemberStateError(e.toString());
      print(e.toString());
    }
  }
}

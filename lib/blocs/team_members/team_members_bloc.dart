import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/team_members/team_members_state.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class TeamMembersBloc extends Bloc<TeamMembersEvent, TeamMembersState> {
  final UserDataRepository userDataRepository;
  final TeamRepository teamRepository;
  TeamMembersBloc({
    required this.userDataRepository,
    required this.teamRepository,
  }) : super(TeamMembersStateInitial());

  List<TeamMemberModel> _teamMemberList = [];
  List<TeamMemberModel> get teamMemberList => _teamMemberList;

  bool isAdmin(UserModel user) {
    final teamMember = _teamMemberList.firstWhereOrNull((el) => el.id == user.uid);
    if (teamMember == null || !teamMember.isAdmin)
      return false;
    else
      return true;
  }

  TeamMembersState get initialState => TeamMembersStateInitial();

  @override
  void onTransition(Transition<TeamMembersEvent, TeamMembersState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<TeamMembersState> mapEventToState(TeamMembersEvent event) async* {
    if (event is GetTeamMembers) {
      yield* _handleGetTeamMembersEvent(event);
    }
  }

  Stream<TeamMembersState> _handleGetTeamMembersEvent(GetTeamMembers event) async* {
    yield TeamMembersStateLoading();
    try {
      final res = await teamRepository.getTeamMemberList(event.teamId);
      _teamMemberList.clear();
      _teamMemberList.addAll(res);
      yield TeamMembersStateLoaded(teamMemberList: res);
    } catch (e) {
      yield TeamMembersStateError(e.toString());
      print(e.toString());
    }
  }
}

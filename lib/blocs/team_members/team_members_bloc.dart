import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/team_members/team_members_state.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/services/user_data_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class TeamMembersBloc extends Bloc<TeamMembersEvent, TeamMembersState> {
  final TeamRepository teamRepository;
  TeamMembersBloc({
    required this.teamRepository,
  }) : super(TeamMembersStateInitial());

  List<UserModel> _teamMemberList = [];
  List<UserModel> get teamMemberList => _teamMemberList;

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
      if (event.teamMembersIds.length == 1) {
        yield TeamMembersStateLoaded(teamMemberList: [event.user]);
      } else {
        final res = await teamRepository.getTeamMembers(event.teamMembersIds);
        _teamMemberList.clear();
        _teamMemberList.addAll(res);
        yield TeamMembersStateLoaded(teamMemberList: res);
      }
    } catch (e) {
      yield TeamMembersStateError(e.toString());
      print(e.toString());
    }
  }
}

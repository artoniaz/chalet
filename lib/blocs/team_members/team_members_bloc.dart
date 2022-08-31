import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/team/team_event.dart';
import 'package:Challet/blocs/team_members/team_members_event.dart';
import 'package:Challet/blocs/team_members/team_members_state.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/repositories/team_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamMembersBloc extends Bloc<TeamMembersEvent, TeamMembersState> {
  final TeamRepository teamRepository;
  final TeamBloc teamBloc;
  TeamMembersBloc({
    required this.teamRepository,
    required this.teamBloc,
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
        _teamMemberList.clear();
        _teamMemberList.addAll([event.user]);
        teamBloc.add(UpdateTeamStats(event.user.chaletsAddedNumber, event.user.chaletReviewsNumber));
      } else {
        final res = await teamRepository.getTeamMembers(event.teamMembersIds);
        _teamMemberList.clear();
        _teamMemberList.addAll(res);

        int chaletAddedNumber = res.fold(0, (a, b) => a + b.chaletsAddedNumber);
        int chaletReviewsNumber = res.fold(0, (a, b) => a + b.chaletReviewsNumber);
        yield TeamMembersStateLoaded(teamMemberList: res);
        teamBloc.add(UpdateTeamStats(chaletAddedNumber, chaletReviewsNumber));
      }
    } catch (e) {
      yield TeamMembersStateError(e.toString());
      print(e.toString());
    }
  }
}

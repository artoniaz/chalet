import 'package:chalet/blocs/team/team_event.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/blocs/team_member/team_member_event.dart';
import 'package:chalet/blocs/team_member/team_member_state.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamMemberBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  final UserDataRepository userDataRepository;
  TeamMemberBloc({
    required this.userDataRepository,
  }) : super(TeamMemberStateInitial());

  TeamMemberState get initialState => TeamMemberStateInitial();

  @override
  void onTransition(Transition<TeamMemberEvent, TeamMemberState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<TeamMemberState> mapEventToState(TeamMemberEvent event) async* {
    if (event is SearchMemberToTeamEvent) {
      yield* _handleSearchTeamMemberEvent(event);
    }
    if (event is ResetTeamMemberBloc) {
      yield* _handleResetTeamMemberBloc(event);
    }
  }

  Stream<TeamMemberState> _handleSearchTeamMemberEvent(SearchMemberToTeamEvent event) async* {
    yield TeamMemberStateLoading();
    try {
      UserModel lookedForUser = await userDataRepository.findUser(event.searchedUserEmail);
      yield TeamMemberStateUserFound(userLookedFor: lookedForUser);
    } catch (e) {
      yield TeamMemberStateError(e.toString());
      print(e.toString());
    }
  }

  Stream<TeamMemberState> _handleResetTeamMemberBloc(ResetTeamMemberBloc event) async* {
    yield TeamMemberStateInitial();
  }
}

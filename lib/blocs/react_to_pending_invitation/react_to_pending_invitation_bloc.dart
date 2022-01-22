import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_event.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_event.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_state.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactToPendingInvitationBloc extends Bloc<ReactToPendingInvitationEvent, ReactToPendingInvitationState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  ReactToPendingInvitationBloc({
    required this.teamRepository,
    required this.userDataRepository,
  }) : super(ReactToPendingInvitationStateInitial());

  ReactToPendingInvitationStateInitial get initialState => ReactToPendingInvitationStateInitial();

  @override
  void onTransition(Transition<ReactToPendingInvitationEvent, ReactToPendingInvitationState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ReactToPendingInvitationState> mapEventToState(ReactToPendingInvitationEvent event) async* {
    if (event is AcceptPendingInvitation) {
      yield* _handleAcceptPendingInvitation(event);
    }
  }

  Stream<ReactToPendingInvitationState> _handleAcceptPendingInvitation(AcceptPendingInvitation event) async* {
    yield ReactToPendingInvitationStateLoading();
    try {
      List<Future> futures = [
        userDataRepository.deletePendingInvitation(event.teamMember.id, event.invitingTeamId),
        teamRepository.acceptInvitation(event.teamMember),
      ];
      await Future.wait(futures);
      yield ReactToPendingInvitationStateAccepted();
    } catch (e) {
      print(e.toString());
      yield ReactToPendingInvitationStateError(e.toString());
    }
  }
}

import 'package:Challet/blocs/react_to_pending_invitation/react_to_pending_invitation_event.dart';
import 'package:Challet/blocs/react_to_pending_invitation/react_to_pending_invitation_state.dart';
import 'package:Challet/blocs/team_feed/team_feed_bloc.dart';
import 'package:Challet/blocs/team_feed/team_feed_event.dart';
import 'package:Challet/repositories/team_repository.dart';
import 'package:Challet/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactToPendingInvitationBloc extends Bloc<ReactToPendingInvitationEvent, ReactToPendingInvitationState> {
  final TeamRepository teamRepository;
  final UserDataRepository userDataRepository;
  final TeamFeedInfoBloc teamFeedInfoBloc;

  ReactToPendingInvitationBloc({
    required this.teamRepository,
    required this.userDataRepository,
    required this.teamFeedInfoBloc,
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
    if (event is DeclinePendingInvitation) {
      yield* _handleDeclinePendingInvitation(event);
    }
  }

  Stream<ReactToPendingInvitationState> _handleAcceptPendingInvitation(AcceptPendingInvitation event) async* {
    yield ReactToPendingInvitationStateLoading();
    try {
      List<Future> futures = [
        userDataRepository.updateUserDataOnAcceptPendingInvitation(
          event.userId,
          event.teamId,
          event.choosenColor,
        ),
        teamRepository.acceptInvitation(
          event.teamId,
          event.userId,
          event.otherTeamId,
          event.choosenColor,
        ),
      ];
      if (event.previousTeamId != null && event.previousTeamId != '') {
        futures.add(teamRepository.deleteTeamMember(event.previousTeamId!, event.userId, event.previousTeamColor!));
      }
      await Future.wait(futures);
      yield ReactToPendingInvitationStateAccepted();
      if (event.feedInfo != null) teamFeedInfoBloc.add(CreateTeamFeedInfo(event.feedInfo!));
    } catch (e) {
      print(e.toString());
      yield ReactToPendingInvitationStateError(e.toString());
    }
  }

  Stream<ReactToPendingInvitationState> _handleDeclinePendingInvitation(DeclinePendingInvitation event) async* {
    yield ReactToPendingInvitationStateLoading();
    try {
      List<Future> futures = [
        userDataRepository.deletePendingInvitationOnDecline(event.declinedTeamId, event.userId),
        teamRepository.declineInvitation(event.declinedTeamId, event.userId),
      ];
      await Future.wait(futures);
      yield ReactToPendingInvitationStateDeclined();
    } catch (e) {
      print(e.toString());
      yield ReactToPendingInvitationStateError(e.toString());
    }
  }
}

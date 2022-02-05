import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_event.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_state.dart';
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
    if (event is DeclinePendingInvitation) {
      yield* _handleDeclinePendingInvitation(event);
    }
  }

  Stream<ReactToPendingInvitationState> _handleAcceptPendingInvitation(AcceptPendingInvitation event) async* {
    yield ReactToPendingInvitationStateLoading();
    try {
      List<Future> futures = [
        userDataRepository.deletePendingInvitationOnAccept(event.userId, event.teamId),
        teamRepository.acceptInvitation(event.teamId, event.userId, event.otherTeamId),
      ];
      await Future.wait(futures);
      yield ReactToPendingInvitationStateAccepted();
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

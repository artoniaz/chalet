import 'package:equatable/equatable.dart';

abstract class ReactToPendingInvitationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AcceptPendingInvitation extends ReactToPendingInvitationEvent {
  final String userId;
  final String teamId;
  final String? otherTeamId;
  AcceptPendingInvitation(this.userId, this.teamId, this.otherTeamId);
}

class DeclinePendingInvitation extends ReactToPendingInvitationEvent {
  final String declinedTeamId;
  final String userId;
  DeclinePendingInvitation(this.declinedTeamId, this.userId);
}

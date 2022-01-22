import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReactToPendingInvitationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AcceptPendingInvitation extends ReactToPendingInvitationEvent {
  final TeamMemberModel teamMember;
  final String? otherTeamId;
  AcceptPendingInvitation(this.teamMember, this.otherTeamId);
}

class DeclinePendingInvitation extends ReactToPendingInvitationEvent {
  final String declinedTeamId;
  final String userId;
  DeclinePendingInvitation(this.declinedTeamId, this.userId);
}

import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReactToPendingInvitationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AcceptPendingInvitation extends ReactToPendingInvitationEvent {
  final TeamMemberModel teamMember;
  final String invitingTeamId;
  AcceptPendingInvitation(this.teamMember, this.invitingTeamId);
}

class DeclinePendingInvitation extends ReactToPendingInvitationEvent {
  final String teamId;
  DeclinePendingInvitation(this.teamId);
}

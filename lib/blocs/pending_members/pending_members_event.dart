import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

abstract class PendingTeamMembersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPendingMembers extends PendingTeamMembersEvent {
  final String teamId;
  GetPendingMembers(this.teamId);
}

class InviteTeamMember extends PendingTeamMembersEvent {
  final TeamMemberModel teamMemberModel;
  InviteTeamMember(this.teamMemberModel);
}

class ResetPendingTeamMembersBloc extends PendingTeamMembersEvent {}

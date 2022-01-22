import 'package:equatable/equatable.dart';

abstract class TeamMembersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTeamMembers extends TeamMembersEvent {
  final String teamId;
  GetTeamMembers(this.teamId);
}

class GetTeamMembersForPendingInvitations extends TeamMembersEvent {
  final List<String> teamIds;
  GetTeamMembersForPendingInvitations(this.teamIds);
}

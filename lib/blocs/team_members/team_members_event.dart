import 'package:chalet/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class TeamMembersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTeamMembers extends TeamMembersEvent {
  final List<String> teamMembersIds;
  final UserModel user;
  GetTeamMembers(this.teamMembersIds, this.user);
}

class GetTeamMembersForPendingInvitations extends TeamMembersEvent {
  final List<String> teamIds;
  GetTeamMembersForPendingInvitations(this.teamIds);
}

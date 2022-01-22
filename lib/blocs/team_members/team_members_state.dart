import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

class TeamMembersState extends Equatable {
  TeamMembersState();

  @override
  List<Object> get props => [];
}

class TeamMembersStateInitial extends TeamMembersState {}

class TeamMembersStateLoading extends TeamMembersState {}

class TeamMembersStateLoaded extends TeamMembersState {
  final List<TeamMemberModel> teamMemberList;
  TeamMembersStateLoaded({required this.teamMemberList});
}

class TeamMembersPendingTeamsStateLoaded extends TeamMembersState {
  final List<List<TeamMemberModel>> teamMemberPendingTeamsList;
  TeamMembersPendingTeamsStateLoaded({required this.teamMemberPendingTeamsList});
}

class TeamMembersStateError extends TeamMembersState {
  final String errorMessage;
  TeamMembersStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

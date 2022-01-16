import 'package:chalet/models/index.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

class PendingTeamMembersState extends Equatable {
  PendingTeamMembersState();

  @override
  List<Object> get props => [];
}

class PendingTeamMembersStateInitial extends PendingTeamMembersState {}

class PendingTeamMembersStateLoading extends PendingTeamMembersState {}

class PendingTeamMembersStateInvited extends PendingTeamMembersState {}

class PendingTeamMemberListLoaded extends PendingTeamMembersState {
  final List<TeamMemberModel> pendingTeamMemberList;
  PendingTeamMemberListLoaded({required this.pendingTeamMemberList});
  @override
  List<Object> get props => [pendingTeamMemberList];
}

class PendingTeamMembersStateError extends PendingTeamMembersState {
  final String errorMessage;
  PendingTeamMembersStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

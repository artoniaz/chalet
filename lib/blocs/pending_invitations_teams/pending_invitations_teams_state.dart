import 'package:chalet/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

class PendingInvitationsTeamsState extends Equatable {
  PendingInvitationsTeamsState();

  @override
  List<Object> get props => [];
}

class PendingInvitationsTeamsStateInitial extends PendingInvitationsTeamsState {}

class PendingInvitationsTeamsStateLoading extends PendingInvitationsTeamsState {}

class PendingInvitationsTeamsStateLoaded extends PendingInvitationsTeamsState {
  final List<List<TeamMemberModel>> pendingInvitationsTeamsMemberList;
  PendingInvitationsTeamsStateLoaded({required this.pendingInvitationsTeamsMemberList});
  @override
  List<Object> get props => [pendingInvitationsTeamsMemberList];
}

class PendingInvitationsTeamsStateError extends PendingInvitationsTeamsState {
  final String errorMessage;
  PendingInvitationsTeamsStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

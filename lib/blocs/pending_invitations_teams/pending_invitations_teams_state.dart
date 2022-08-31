import 'package:Challet/models/team_model.dart';
import 'package:equatable/equatable.dart';

class PendingInvitationsTeamsState extends Equatable {
  PendingInvitationsTeamsState();

  @override
  List<Object> get props => [];
}

class PendingInvitationsTeamsStateInitial extends PendingInvitationsTeamsState {}

class PendingInvitationsTeamsStateLoading extends PendingInvitationsTeamsState {}

class PendingInvitationsTeamsStateLoaded extends PendingInvitationsTeamsState {
  final List<TeamModel> pendingInvitationsTeamList;
  PendingInvitationsTeamsStateLoaded({required this.pendingInvitationsTeamList});
  @override
  List<Object> get props => [pendingInvitationsTeamList];
}

class PendingInvitationsTeamsStateError extends PendingInvitationsTeamsState {
  final String errorMessage;
  PendingInvitationsTeamsStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

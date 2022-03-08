import 'package:equatable/equatable.dart';

abstract class PendingInvitationsTeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPendingInvitationsTeams extends PendingInvitationsTeamEvent {
  final List<String> teamIds;
  GetPendingInvitationsTeams(this.teamIds);
}

class ResetPendingInvitationsTeam extends PendingInvitationsTeamEvent {}

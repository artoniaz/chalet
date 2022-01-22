import 'package:equatable/equatable.dart';

abstract class PendingInvitationsTeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPendingInvitationsTeamMembers extends PendingInvitationsTeamEvent {
  final List<String> teamIds;
  GetPendingInvitationsTeamMembers(this.teamIds);
}

class ResetPendingInvitationsTeamMembers extends PendingInvitationsTeamEvent {}

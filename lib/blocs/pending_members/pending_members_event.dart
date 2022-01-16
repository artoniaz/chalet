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
  final String pendingUserId;
  final String pendingUserName;
  final String teamId;
  InviteTeamMember(this.pendingUserId, this.pendingUserName, this.teamId);
}

class ResetPendingTeamMembersBloc extends PendingTeamMembersEvent {}

import 'package:Challet/models/team_model.dart';
import 'package:equatable/equatable.dart';

abstract class PendingTeamMembersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPendingTeamMembers extends PendingTeamMembersEvent {
  final TeamModel team;
  final String? newPendingUserId;
  GetPendingTeamMembers(this.team, [this.newPendingUserId]);
}

class InviteTeamMember extends PendingTeamMembersEvent {
  final TeamModel team;
  final String pendingMemberId;
  InviteTeamMember(this.team, this.pendingMemberId);
}

class ResetPendingTeamMembersBloc extends PendingTeamMembersEvent {}

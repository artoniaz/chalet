import 'package:equatable/equatable.dart';

abstract class DeleteTeamMemberEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteTeamMember extends DeleteTeamMemberEvent {
  final String userToDeleteId;
  final String teamId;
  DeleteTeamMember(this.userToDeleteId, this.teamId);
}

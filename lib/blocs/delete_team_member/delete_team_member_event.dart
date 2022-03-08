import 'package:chalet/models/team_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class DeleteTeamMemberEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteTeamMember extends DeleteTeamMemberEvent {
  final TeamModel team;
  final String userToDeleteId;
  final UserModel adminUser;
  final double choosenColor;
  DeleteTeamMember(this.team, this.userToDeleteId, this.adminUser, this.choosenColor);
}

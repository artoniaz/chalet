import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/services/team_service.dart';

class TeamRepository {
  final _teamService = TeamService();

  Future<String> createTeam(String userId, String userName, String teamName) =>
      _teamService.createTeam(userId, userName, teamName);

  Future<List<TeamMemberModel>> getTeamMemberList(String teamId) => _teamService.getTeamMemberList(teamId);

  Future<List<TeamMemberModel>> getPendingTeamMemberList(String teamId) =>
      _teamService.getPendingTeamMemberList(teamId);

  Future<void> createPendingTeamMember(TeamMemberModel teamMemberModel) =>
      _teamService.createPendingTeamMember(teamMemberModel);

  Future<void> deleteTeamMember(String userToDeleteId, String teamId) =>
      _teamService.deleteTeamMember(userToDeleteId, teamId);

  Future<void> acceptInvitation(TeamMemberModel teamMember, String? otherTeamId) =>
      _teamService.acceptInvitation(teamMember, otherTeamId);

  Future<void> declineInvitation(String teamToDeclineId, String decliningUserId) =>
      _teamService.declineInvitation(teamToDeclineId, decliningUserId);
}

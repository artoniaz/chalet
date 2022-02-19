import 'package:chalet/models/team_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/team_service.dart';

class TeamRepository {
  final _teamService = TeamService();

  Future<String> createTeam(String userId, String userName, String teamName) =>
      _teamService.createTeam(userId, userName, teamName);

  Future<List<UserModel>> getTeamMembers(List<String> teamMembersId) => _teamService.getTeamMembers(teamMembersId);

  Future<List<UserModel>> getPendingTeamMembers(List<String> pendingTeamMembersId) =>
      _teamService.getPendingTeamMembers(pendingTeamMembersId);

  Future<void> createPendingTeamMember(String teamId, String pendingMemberId) =>
      _teamService.createPendingTeamMember(teamId, pendingMemberId);

  Future<void> deleteTeamMember(String teamId, String userToDeleteId, double choosenColor) =>
      _teamService.deleteTeamMember(teamId, userToDeleteId, choosenColor);

  Future<void> acceptInvitation(String teamId, String userId, String? otherTeamId, double choosenColor) =>
      _teamService.acceptInvitation(teamId, userId, otherTeamId, choosenColor);

  Future<void> declineInvitation(String teamToDeclineId, String decliningUserId) =>
      _teamService.declineInvitation(teamToDeclineId, decliningUserId);

  Future<TeamModel> getTeam(String teamId) => _teamService.getTeam(teamId);
}

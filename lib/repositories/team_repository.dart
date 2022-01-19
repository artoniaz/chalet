import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/services/team_service.dart';

class TeamRepository {
  final _teamService = TeamService();

  Future<String> createTeam(String userId, String userName, String teamName) =>
      _teamService.createTeam(userId, userName, teamName);

  Future<List<TeamMemberModel>> getTeamMemberList(String teamId) => _teamService.getTeamMemberList(teamId);

  Future<List<TeamMemberModel>> getPendingTeamMemberList(String teamId) =>
      _teamService.getPendingTeamMemberList(teamId);

  Future<void> createPendingTeamMember(String pendingUserId, String userName, String teamId) =>
      _teamService.createPendingTeamMember(pendingUserId, userName, teamId);

  Future<void> deleteTeamMember(String userToDeleteId, String teamId) =>
      _teamService.deleteTeamMember(userToDeleteId, teamId);
}

import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/services/team_service.dart';

class TeamRepository {
  final _teamService = TeamService();

  Future<String> createTeam(String userId, String userName, String teamName) =>
      _teamService.createTeam(userId, userName, teamName);

  Future<List<TeamMemberModel>> getTeamMemberList(String teamId) => _teamService.getTeamMemberList(teamId);
}

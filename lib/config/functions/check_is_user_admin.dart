import 'package:chalet/models/team_model.dart';
import 'package:chalet/models/user_model.dart';

bool isUserTeamAdmin(String teamAdminId, String userId) {
  return teamAdminId == userId;
}

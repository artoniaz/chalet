import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/index.dart';

class UserDataRepository {
  final _userDataService = UserDataService();

  Future<void> setUserDataOnRegister(String userId, UserModel user) =>
      _userDataService.setUserDataOnRegister(userId, user);

  Stream<UserModel> getUserData(String userId) => _userDataService.getUserData(userId);

  Future<void> updateUserDisplayName(String userId, String displayName) =>
      _userDataService.updateUserDisplayName(userId, displayName);

  Future<void> updateUserTeamData(String userId, String teamId, double? choosenColor) =>
      _userDataService.updateUserTeamData(
        userId,
        teamId,
        choosenColor,
      );

  Future<void> removeUserData(String userId) => _userDataService.removeUserData(userId);

  Future<UserModel> findUser(String userLookedForEmail) => _userDataService.findUser(userLookedForEmail);

  Future<void> addUserInvitationToTeam(String userId, String invitingTeamId) =>
      _userDataService.addUserInvitationToTeam(userId, invitingTeamId);

  Future<void> updateUserDataOnAcceptPendingInvitation(String userId, String teamId, double choosenColor) =>
      _userDataService.updateUserDataOnAcceptPendingInvitation(userId, teamId, choosenColor);

  Future<void> deletePendingInvitationOnDecline(
    String teamToDeclineId,
    String decliningUserId,
  ) =>
      _userDataService.deletePendingInvitationOnDecline(teamToDeclineId, decliningUserId);

  Future<void> addCompletedAchievement(String userId, achievementsIds completedAchievement) =>
      _userDataService.addCompletedAchievement(userId, completedAchievement);
}

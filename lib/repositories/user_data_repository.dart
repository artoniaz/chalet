import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/index.dart';

class UserDataRepository {
  final _userDataService = UserDataService();

  Future<void> setUserDataOnRegister(String userId, UserModel user) =>
      _userDataService.setUserDataOnRegister(userId, user);

  Stream<UserModel> getUserData(String userId) => _userDataService.getUserData(userId);

  Future<void> updateUserDisplayName(String userId, String displayName) =>
      _userDataService.updateUserDisplayName(userId, displayName);

  Future<void> updateUserTeamData(String userId, String teamId, String teamName) =>
      _userDataService.updateUserTeamData(userId, teamId, teamName);

  Future<void> removeUserData(String userId) => _userDataService.removeUserData(userId);

  Future<UserModel> findUser(String userLookedForEmail) => _userDataService.findUser(userLookedForEmail);

  Future<void> addUserInvitationToTeam(String userId, String invitingTeamId) =>
      _userDataService.addUserInvitationToTeam(userId, invitingTeamId);

  Future<void> deletePendingInvitation(String userId, String invitingTeamId) =>
      _userDataService.deletePendingInvitation(userId, invitingTeamId);
}

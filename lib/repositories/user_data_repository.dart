import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/index.dart';

class UserDataRepository {
  final _userDataService = UserDataService();

  Future<void> setUserDataOnRegister(String userId, UserModel user) =>
      _userDataService.setUserDataOnRegister(userId, user);

  Stream<UserModel> getUserData(String userId) => _userDataService.getUserData(userId);

  Future<void> updateUserDisplayName(String userId, String displayName) =>
      _userDataService.updateUserDisplayName(userId, displayName);

  Future<void> removeUserData(String userId) => _userDataService.removeUserData(userId);
}

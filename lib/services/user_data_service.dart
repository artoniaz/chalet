import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  // collection reference
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection("users");
  final String PENDING_INVITATIONS_IDS = 'pendingInvitationsIds';
  final String TEAM_ID = 'teamId';
  final String TEAM_NAME = 'teamName';
  final String ACHIEVEMENTS_IDS = 'achievementsIds';
  final String CHOOSEN_COLOR = 'choosenColor';

  Stream<UserModel> getUserData(String userId) {
    return _usersCollection.doc(userId).snapshots().map((snapshot) => UserModel.fromJson(snapshot));
  }

  Future<void> setUserDataOnRegister(String userId, UserModel user) async {
    return await _usersCollection.doc(userId).set(user.toJson());
  }

  Future<void> updateUserDisplayName(String userId, String displayName) async {
    try {
      await _usersCollection.doc(userId).update({'displayName': displayName});
    } catch (e) {
      print(e);
      throw 'Nie udało się zaktualizować danych użytkownika';
    }
  }

  Future<void> updateUserTeamData(String userId, String teamId, double? choosenColor) async {
    try {
      await _usersCollection.doc(userId).update({
        TEAM_ID: teamId,
        CHOOSEN_COLOR: choosenColor,
      });
    } catch (e) {
      print(e);
      throw 'Nie udało się zaktualizować danych użytkownika';
    }
  }

  Future<void> removeUserData(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw 'Nie udało się usunąć danych użytkownika. Napsz do nas na pomoc@chalet.com w celu pełnego usunięcia Twoich danych';
    }
  }

  Future<UserModel> findUser(String userLookedForEmail) async {
    try {
      var lookedForUser = await _usersCollection.where('email', isEqualTo: userLookedForEmail).get();
      return lookedForUser.docs.map((el) => UserModel.fromJson(el)).toList().first;
    } catch (e) {
      throw 'Nie znaleziono użytkownika o podanym adresie email. Podaj maila zarejestrowanego użytkownika.';
    }
  }

  Future<void> addUserInvitationToTeam(String userId, String invitingTeamId) async {
    try {
      await _usersCollection.doc(userId).update({
        PENDING_INVITATIONS_IDS: FieldValue.arrayUnion([invitingTeamId]),
      });
    } catch (e) {
      throw 'Nie udało się wysłać zaproszenia użytkownikowi.';
    }
  }

  Future<void> updateUserDataOnAcceptPendingInvitation(String userId, String teamId, double choosenColor) async {
    try {
      await _usersCollection.doc(userId).update({
        PENDING_INVITATIONS_IDS: null,
        TEAM_ID: teamId,
        CHOOSEN_COLOR: choosenColor,
      });
    } catch (e) {
      throw 'Nie udało się usunąć zaproszenia z profilu użytkownika';
    }
  }

  Future<void> deletePendingInvitationOnDecline(String teamToDeclineId, String decliningUserId) async {
    try {
      await _usersCollection.doc(decliningUserId).update({
        PENDING_INVITATIONS_IDS: FieldValue.arrayRemove([teamToDeclineId])
      });
    } catch (e) {
      throw 'Nie udało się odrzucić zaproszenia z profilu użytkownika';
    }
  }

  Future<void> addCompletedAchievement(String userId, achievementsIds completedAchievement) async {
    try {
      await _usersCollection.doc(userId).update({
        ACHIEVEMENTS_IDS: FieldValue.arrayUnion([completedAchievement]),
      });
    } catch (e) {
      throw 'Nie udało się zapisać osiągnięcia.';
    }
  }
}

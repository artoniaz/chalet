import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  // collection reference
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection("users");

  @override
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

  Future<void> updateUserTeamData(String userId, String teamId, String teamName) async {
    try {
      await _usersCollection.doc(userId).update({
        'teamId': teamId,
        'teamName': teamName,
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
      throw 'Nie znaleziono użytkownika o podanym adresie email';
    }
  }

  Future<void> addUserInvitationToTeam(String userId, String invitingTeamId) async {
    try {
      await _usersCollection.doc(userId).update({
        'pendingInvitationsIds': FieldValue.arrayUnion([invitingTeamId]),
      });
    } catch (e) {
      throw 'Nie udało się wysłać zaproszenia użytkownikowi.';
    }
  }

  Future<void> deletePendingInvitation(String userId, String invitingTeamId) async {
    try {
      await _usersCollection.doc(userId).update({
        'pendingInvitationsIds': FieldValue.arrayRemove([invitingTeamId]),
      });
    } catch (e) {
      throw 'Nie udało się usunąć zaproszenia z profilu użytkownika';
    }
  }
}

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

  Future<void> removeUserData(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw 'Nie udało się usunąć danych użytkownika. Napsz do nas na pomoc@chalet.com w celu pełnego usunięcia Twoich danych';
    }
  }
}

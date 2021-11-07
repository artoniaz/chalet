import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future<UserModel> getUserData(String uid) async {
    try {
      final userSnapshot = await userCollection.doc(uid).get();
      return UserModel.fromJson(userSnapshot.data());
    } catch (e) {
      throw 'Nie udało się pobrać danych użytkownika';
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      userCollection.doc(user.uid).update({
        "displayName": user.displayName,
      });
    } catch (e) {
      throw 'Nie udało się zapisać nowych danych';
    }
  }
}

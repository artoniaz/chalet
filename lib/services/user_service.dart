import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String uid;
  UserService({required this.uid});
  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // userData from snapshot
  UserDataModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: uid,
      favourites: (snapshot.data() as dynamic)['favourites'] ?? [],
    );
  }

  // get user doc stream
  Stream<UserDataModel>? get userData {
    userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

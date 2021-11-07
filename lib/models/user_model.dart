import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  String email;
  String? displayName;
  String? photoURL;
  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  factory UserModel.fromJson(Object? json) {
    return UserModel(
      uid: (json as dynamic)['uid']?.toString() ?? '',
      email: (json as dynamic)['email']?.toString() ?? '',
      displayName: (json as dynamic)['displayName']?.toString() ?? '',
      photoURL: (json as dynamic)['photoURL']?.toString() ?? '',
    );
  }

  factory UserModel.userModelFromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
      };
}

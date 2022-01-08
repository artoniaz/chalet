import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? teamId;
  final String? teamName;
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.teamId,
    this.teamName,
  });

  factory UserModel.fromJson(Object? json) {
    return UserModel(
      uid: (json as dynamic)['uid']?.toString() ?? '',
      email: (json as dynamic)['email']?.toString() ?? '',
      displayName: (json as dynamic)['displayName']?.toString() ?? '',
      photoURL: (json as dynamic)['photoURL']?.toString() ?? '',
      teamName: (json as dynamic)['teamName']?.toString() ?? '',
      teamId: (json as dynamic)['teamId']?.toString() ?? '',
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

  factory UserModel.fromData(String uid, String email, String name) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: name,
      photoURL: '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'teamId': teamId,
        'teamName': teamName,
      };
}

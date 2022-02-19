import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? teamId;
  final List<String>? pendingInvitationsIds;
  final int chaletsAddedNumber;
  final int chaletReviewsNumber;
  final List<String>? achievementsIds;
  final double? choosenColor;
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.teamId,
    this.pendingInvitationsIds,
    this.chaletsAddedNumber = 0,
    this.chaletReviewsNumber = 0,
    this.achievementsIds,
    this.choosenColor,
  });

  factory UserModel.fromJson(Object? json) {
    return UserModel(
      uid: (json as dynamic)['uid']?.toString() ?? '',
      email: (json as dynamic)['email']?.toString() ?? '',
      displayName: (json as dynamic)['displayName']?.toString() ?? '',
      photoURL: (json as dynamic)['photoURL']?.toString() ?? '',
      teamId: (json as dynamic)['teamId']?.toString() ?? '',
      chaletsAddedNumber: (json as dynamic)['chaletsAddedNumber']?.toInt() ?? 0,
      chaletReviewsNumber: (json as dynamic)['chaletReviewsNumber']?.toInt() ?? 0,
      choosenColor: (json as dynamic)['choosenColor']?.toDouble() ?? 0.0,
      pendingInvitationsIds: (json as dynamic)['pendingInvitationsIds'] == null
          ? []
          : List<String>.from((json as dynamic)['pendingInvitationsIds'].map((el) => el)),
      achievementsIds: (json as dynamic)['achievementsIds'] == null
          ? []
          : List<String>.from((json as dynamic)['achievementsIds'].map((el) => el)),
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
        'pendingInvitationsIds': pendingInvitationsIds,
        'chaletsAddedNumber': chaletsAddedNumber,
        'chaletReviewsNumber': chaletReviewsNumber,
        'achievementsIds': achievementsIds,
        'choosenColor': choosenColor,
      };
}

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? teamId;
  final List<String>? pendingInvitationsIds;
  final int chaletsAddedNumber;
  final int chaletReviewsNumber;
  final List<String>? achievementsIds;
  final double? choosenColor;
  final String? avatarId;
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.teamId,
    this.pendingInvitationsIds,
    this.chaletsAddedNumber = 0,
    this.chaletReviewsNumber = 0,
    this.achievementsIds,
    this.choosenColor,
    this.avatarId,
  });

  factory UserModel.fromJson(Object? json) {
    return UserModel(
      uid: (json as dynamic)['uid']?.toString() ?? '',
      email: (json as dynamic)['email']?.toString() ?? '',
      displayName: (json as dynamic)['displayName']?.toString() ?? '',
      teamId: (json as dynamic)['teamId']?.toString() ?? '',
      avatarId: (json as dynamic)['avatarId']?.toString() ?? '',
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
    );
  }

  factory UserModel.fromData(String uid, String email, String name, String avatarId) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: name,
      avatarId: avatarId,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'teamId': teamId,
        'pendingInvitationsIds': pendingInvitationsIds,
        'chaletsAddedNumber': chaletsAddedNumber,
        'chaletReviewsNumber': chaletReviewsNumber,
        'achievementsIds': achievementsIds,
        'choosenColor': choosenColor,
        'avatarId': avatarId,
      };
}

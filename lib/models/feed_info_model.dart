import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedInfoModel {
  String id;
  String teamId;
  String userId;
  String chaletId;
  String chaletName;
  String userName;
  FeedInfoRole role;
  double chaletRating;
  Timestamp created;
  List<CongratsSenderModel> congratsSenderList;

  FeedInfoModel({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.chaletId,
    required this.chaletName,
    required this.userName,
    required this.role,
    required this.chaletRating,
    required this.created,
    required this.congratsSenderList,
  });

  factory FeedInfoModel.fromJson(Object? json, String id) {
    return FeedInfoModel(
        id: id,
        teamId: (json as dynamic)['teamId'] ?? '',
        userId: (json as dynamic)['userId'] ?? '',
        chaletId: (json as dynamic)['chaletId'] ?? '',
        chaletName: (json as dynamic)['chaletName'] ?? '',
        userName: (json as dynamic)['userName'] ?? '',
        role: FeedInfoRole.values.firstWhere((el) => el.name == (json as dynamic)['role']),
        chaletRating: (json as dynamic)['chaletRating'].toDouble() ?? 0.0,
        created: (json as dynamic)['created'] ?? '',
        congratsSenderList: List<CongratsSenderModel>.from(
            (json as dynamic)["congratsSenderList"].map((item) => CongratsSenderModel.fromJson(item))));
  }

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'userId': userId,
        'chaletId': chaletId,
        'chaletName': chaletName,
        'userName': userName,
        'role': role.name,
        'chaletRating': chaletRating,
        'created': created,
        'congratsSenderList': congratsSenderList,
      };
}

class CongratsSenderModel {
  String userId;
  String userName;

  CongratsSenderModel({
    required this.userId,
    required this.userName,
  });

  factory CongratsSenderModel.fromJson(Object? json) {
    return CongratsSenderModel(
      userId: (json as dynamic)['userId'] ?? '',
      userName: (json as dynamic)['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
      };
}

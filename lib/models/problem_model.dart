import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemModel {
  String chaletId;
  String userId;
  String chaletName;
  String problemDescription;
  bool isSolved;
  Timestamp created;
  ProblemModel({
    required this.chaletId,
    required this.userId,
    required this.chaletName,
    required this.problemDescription,
    required this.isSolved,
    required this.created,
  });

  factory ProblemModel.fromJson(Object? json) {
    return ProblemModel(
      chaletId: (json as dynamic)['chaletId'] ?? '',
      userId: (json as dynamic)['userId'] ?? '',
      chaletName: (json as dynamic)['chaletName'] ?? '',
      problemDescription: (json as dynamic)['problemDescription'] ?? '',
      isSolved: (json as dynamic)['isSolved'] ?? false,
      created: (json as dynamic)['created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'chaletId': chaletId,
        'userId': userId,
        'chaletName': chaletName,
        'problemDescription': problemDescription,
        'isSolved': isSolved,
        'created': created,
      };
}

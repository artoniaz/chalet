class ProblemModel {
  String chaletId;
  String userId;
  String chaletName;
  String problemDescription;
  bool isSolved;
  ProblemModel({
    required this.chaletId,
    required this.userId,
    required this.chaletName,
    required this.problemDescription,
    required this.isSolved,
  });

  factory ProblemModel.fromJson(Object? json) {
    return ProblemModel(
      chaletId: (json as dynamic)['chaletId'] ?? '',
      userId: (json as dynamic)['userId'] ?? '',
      chaletName: (json as dynamic)['chaletName'] ?? '',
      problemDescription: (json as dynamic)['problemDescription'] ?? '',
      isSolved: (json as dynamic)['isSolved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'chaletId': chaletId,
        'userId': userId,
        'chaletName': chaletName,
        'problemDescription': problemDescription,
        'isSolved': isSolved,
      };
}

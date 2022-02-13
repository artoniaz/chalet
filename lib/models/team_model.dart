class TeamModel {
  String id;
  String name;
  String teamAdminId;
  String teamAdminName;
  List<String>? membersIds;
  List<String>? pendingMembersIds;
  int? chaletAddedNumber;
  int? chaletReviewsNumber;

  TeamModel({
    required this.id,
    required this.name,
    required this.teamAdminId,
    required this.teamAdminName,
    required this.membersIds,
    required this.pendingMembersIds,
    this.chaletAddedNumber,
    this.chaletReviewsNumber,
  });

  factory TeamModel.fromJson(Object? json, String id) {
    return TeamModel(
      id: id,
      name: (json as dynamic)['name'] ?? '',
      teamAdminId: (json as dynamic)['teamAdminId'] ?? '',
      teamAdminName: (json as dynamic)['teamAdminName'] ?? '',
      membersIds: (json as dynamic)['membersIds'] == null
          ? []
          : List<String>.from((json as dynamic)['membersIds'].map((el) => el)),
      pendingMembersIds: (json as dynamic)['pendingMembersIds'] == null
          ? []
          : List<String>.from((json as dynamic)['pendingMembersIds'].map((el) => el)),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'teamAdminId': teamAdminId,
        'teamAdminName': teamAdminName,
        'membersIds': membersIds,
        'pendingMembersIds': pendingMembersIds,
      };
}

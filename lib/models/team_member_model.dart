class TeamMemberModel {
  String id;
  String name;
  bool isAdmin;
  String teamName;
  String teamId;
  TeamMemberModel({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.teamId,
    required this.teamName,
  });

  factory TeamMemberModel.fromJson(Object? json, String id) {
    return TeamMemberModel(
      id: id,
      name: (json as dynamic)['name'] ?? '',
      teamName: (json as dynamic)['teamName'] ?? '',
      teamId: (json as dynamic)['teamId'] ?? '',
      isAdmin: (json as dynamic)['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'teamName': teamName,
        'teamId': teamId,
        'isAdmin': isAdmin,
      };
}

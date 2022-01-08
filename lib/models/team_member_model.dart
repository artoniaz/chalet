class TeamMemberModel {
  String id;
  String name;
  bool isAdmin;
  TeamMemberModel({
    required this.id,
    required this.name,
    required this.isAdmin,
  });

  factory TeamMemberModel.fromJson(Object? json, String id) {
    return TeamMemberModel(
      id: id,
      name: (json as dynamic)['name'] ?? '',
      isAdmin: (json as dynamic)['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isAdmin': isAdmin,
      };
}

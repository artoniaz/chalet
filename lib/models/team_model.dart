class TeamModel {
  String id;
  String name;
  String? teamAdminId;

  TeamModel({
    required this.id,
    required this.name,
    this.teamAdminId,
  });

  factory TeamModel.fromJson(Object? json, String id) {
    return TeamModel(
      id: id,
      name: (json as dynamic)['name'] ?? '',
      teamAdminId: (json as dynamic)['teamAdminId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'teamAdminId': teamAdminId,
      };
}

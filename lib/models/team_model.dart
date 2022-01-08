class TeamModel {
  String id;
  String name;
  TeamModel({
    required this.id,
    required this.name,
  });

  factory TeamModel.fromJson(Object? json, String id) {
    return TeamModel(
      id: id,
      name: (json as dynamic)['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

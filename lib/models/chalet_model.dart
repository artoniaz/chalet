class ChaletModel {
  String name;
  double rating;
  double quality;
  double clean;
  double paper;
  double privacy;
  String? description;
  ChaletModel({
    required this.name,
    required this.rating,
    required this.quality,
    required this.clean,
    required this.paper,
    required this.privacy,
    this.description,
  });
}

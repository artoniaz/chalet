import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';

class ChaletModel {
  String id;
  String name;
  double rating;
  double quality;
  double clean;
  double paper;
  double privacy;
  String? description;
  List<ImageModelUrl> images;
  ChaletModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.quality,
    required this.clean,
    required this.paper,
    required this.privacy,
    this.description,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'quality': quality,
        'clean': clean,
        'paper': paper,
        'privacy': privacy,
        'description': description,
        'images': images,
      };
}

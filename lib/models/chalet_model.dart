import 'package:chalet/models/image_model_url.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ChaletModel {
  String id;
  String name;
  double rating;
  int numberRating;
  int numberDetailedRating;
  double clean;
  double paper;
  double privacy;
  String descriptionHowToGet;
  String? description;
  List<ImageModelUrl> images;
  dynamic position;
  bool isVerified;
  ChaletModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.numberRating,
    required this.numberDetailedRating,
    required this.clean,
    required this.paper,
    required this.privacy,
    required this.descriptionHowToGet,
    this.description,
    required this.images,
    required this.position,
    required this.isVerified,
  });

  factory ChaletModel.fromJson(Object? json, String id) {
    return ChaletModel(
        id: id,
        name: (json as dynamic)['name'] ?? '',
        rating: (json as dynamic)['rating'].toDouble() ?? 0.0,
        numberRating: (json as dynamic)['numberRating'] ?? 0,
        numberDetailedRating: (json as dynamic)['numberDetailedRating'] ?? 0,
        descriptionHowToGet: (json as dynamic)['descriptionHowToGet']?.toString() ?? '',
        clean: (json as dynamic)['clean']?.toDouble() ?? 0.0,
        paper: (json as dynamic)['paper']?.toDouble() ?? 0.0,
        privacy: (json as dynamic)['privacy']?.toDouble() ?? 0.0,
        position: (json as dynamic)['position'] ?? GeoFirePoint(0, 0),
        isVerified: (json as dynamic)['isVerified'] ?? false,
        images: List<ImageModelUrl>.from(
          (json as dynamic)["images"].map((item) {
            return new ImageModelUrl(
                imageUrlOriginalSize: item['imageUrlOriginalSize'] ?? '',
                imageUrlMinSize: item['imageUrlMinSize'] ?? '',
                isDefault: item['isDefault'] ?? false);
          }),
        ),
        description: (json as dynamic)['description'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'rating': rating,
        'numberRating': numberRating,
        'numberDetailedRating': numberDetailedRating,
        'descriptionHowToGet': descriptionHowToGet,
        'clean': clean,
        'paper': paper,
        'privacy': privacy,
        'description': description,
        'images': images,
        'position': position,
        'isVerified': isVerified,
      };
}

import 'package:chalet/models/image_model_url.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

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
  String venueDescription;
  String? description;
  List<ImageModelUrl> images;
  dynamic position;
  bool isVerified;
  bool is24;
  String creatorName;
  String creatorId;
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
    required this.is24,
    required this.venueDescription,
    required this.creatorName,
    required this.creatorId,
  });

  factory ChaletModel.fromJson(Object? json, String id) {
    return ChaletModel(
        id: id,
        name: (json as dynamic)['name'] ?? '',
        rating: (json as dynamic)['rating'].toDouble() ?? 0.0,
        numberRating: (json as dynamic)['numberRating'] ?? 0,
        numberDetailedRating: (json as dynamic)['numberDetailedRating'] ?? 0,
        descriptionHowToGet: (json as dynamic)['descriptionHowToGet']?.toString() ?? '',
        venueDescription: (json as dynamic)['venueDescription']?.toString() ?? '',
        creatorName: (json as dynamic)['creatorName']?.toString() ?? '',
        creatorId: (json as dynamic)['creatorId']?.toString() ?? '',
        clean: (json as dynamic)['clean']?.toDouble() ?? 0.0,
        paper: (json as dynamic)['paper']?.toDouble() ?? 0.0,
        privacy: (json as dynamic)['privacy']?.toDouble() ?? 0.0,
        position: (json as dynamic)['position'] ?? GeoFirePoint(0, 0),
        isVerified: (json as dynamic)['isVerified'] ?? false,
        is24: (json as dynamic)['is24'] ?? false,
        images: List<ImageModelUrl>.from(
          (json as dynamic)["images"].map((item) {
            return new ImageModelUrl(
                imageUrlOriginalSize: item['imageUrlOriginalSize'] ?? '',
                // imageUrlMinSize: item['imageUrlMinSize'] ?? '',
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
        'venueDescription': venueDescription,
        'clean': clean,
        'paper': paper,
        'privacy': privacy,
        'description': description,
        'images': images,
        'position': position.data,
        'isVerified': isVerified,
        'is24': is24,
        'creatorName': creatorName,
        'creatorId': creatorId,
      };
}

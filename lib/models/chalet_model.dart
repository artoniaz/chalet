import 'package:chalet/models/custom_geo_point.dart';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ChaletModel {
  // String id;
  String name;
  double rating;
  double quality;
  double clean;
  double paper;
  double privacy;
  String? description;
  List<ImageModelUrl> images;
  dynamic position;
  ChaletModel({
    // required this.id,
    required this.name,
    required this.rating,
    required this.quality,
    required this.clean,
    required this.paper,
    required this.privacy,
    this.description,
    required this.images,
    required this.position,
  });

  factory ChaletModel.fromJson(Object? json) {
    return ChaletModel(
        // id: (json as dynamic)['id'] as String,
        name: (json as dynamic)['name'] ?? '',
        rating: (json as dynamic)['rating'].toDouble() ?? 0.0,
        quality: (json as dynamic)['quality']?.toDouble() ?? 0.0,
        clean: (json as dynamic)['clean']?.toDouble() ?? 0.0,
        paper: (json as dynamic)['paper']?.toDouble() ?? 0.0,
        privacy: (json as dynamic)['privacy']?.toDouble() ?? 0.0,
        position: (json as dynamic)['position'] ?? GeoFirePoint(0, 0),
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
        // 'id': id,
        'name': name,
        'rating': rating,
        'quality': quality,
        'clean': clean,
        'paper': paper,
        'privacy': privacy,
        'description': description,
        'images': images,
        'position': position,
      };
}

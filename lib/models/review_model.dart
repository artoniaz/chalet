import 'package:chalet/models/review_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String id;
  String chaletId;
  String userId;
  String userName;
  double rating;
  String description;
  Timestamp created;
  bool hasUserAddedFullReview;
  ReviewDetailsModel? reviewDetails;

  ReviewModel({
    required this.id,
    required this.chaletId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.description,
    required this.created,
    required this.hasUserAddedFullReview,
    this.reviewDetails,
  });

  factory ReviewModel.fromJson(Object? json, String id) {
    return ReviewModel(
      id: id,
      chaletId: (json as dynamic)['chaletId'] ?? '',
      userId: (json as dynamic)['userId'] ?? '',
      userName: (json as dynamic)['userName'] ?? '',
      rating: (json as dynamic)['rating'] ?? '',
      description: (json as dynamic)['description'] ?? '',
      created: (json as dynamic)['created'] ?? '',
      hasUserAddedFullReview: (json as dynamic)['hasUserAddedFullReview'] ?? '',
      reviewDetails: (json as dynamic)['reviewDetails'] == null
          ? null
          : ReviewDetailsModel.fromJson((json as dynamic)['reviewDetails']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'chaletId': chaletId,
        'userName': userName,
        'rating': rating,
        'description': description,
        'created': created,
        'hasUserAddedFullReview': hasUserAddedFullReview,
        'reviewDetails': reviewDetails?.toJson()
      };
}

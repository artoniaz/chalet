import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/services/review_service.dart';

class ReviewRepository {
  final _reviewService = ReviewService();

  Future<List<ReviewModel>> getReviewsForChalet(String chaletId) => _reviewService.getReviewsForChalet(chaletId);

  Future<List<ReviewModel>> getMoreReviewsForChalet(String chaletId, ReviewModel lastReview) =>
      _reviewService.getMoreReviewsForChalet(chaletId, lastReview);

  Future<List<ReviewModel>> getLastUserReviewForChalet(String chaletId, String userId) =>
      _reviewService.getLastUserReviewForChalet(chaletId, userId);

  Future<void> addDetailsReviewToQuickReview(String chaletId, String reviewId, ReviewDetailsModel reviewDetails) =>
      _reviewService.addDetailsReviewToQuickReview(chaletId, reviewId, reviewDetails);
}

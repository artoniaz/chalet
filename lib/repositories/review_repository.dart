import 'package:chalet/models/review_model.dart';
import 'package:chalet/services/review_service.dart';

class ReviewRepository {
  final _reviewService = ReviewService();

  Future<List<ReviewModel>> getReviewsForChalet(String chaletId) => _reviewService.getReviewsForChalet(chaletId);
  Future<List<ReviewModel>> getMoreReviewsForChalet(String chaletId, ReviewModel lastReview) =>
      _reviewService.getMoreReviewsForChalet(chaletId, lastReview);
}

import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/models/review_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLastUserReviewForChalet extends AddReviewEvent {
  final String chaletId;
  final String userId;
  GetLastUserReviewForChalet({required this.chaletId, required this.userId});
}

class CreateQuickReview extends AddReviewEvent {
  final ReviewModel review;
  final FeedInfoModel feedInfo;
  CreateQuickReview({
    required this.review,
    required this.feedInfo,
  });
}

class GoToFullReviewDialog extends AddReviewEvent {}

class AddDetailsReviewToQuickReview extends AddReviewEvent {
  final String chaletId;
  final String reviewId;
  final ReviewDetailsModel reviewDetails;

  AddDetailsReviewToQuickReview(this.chaletId, this.reviewId, this.reviewDetails);
}

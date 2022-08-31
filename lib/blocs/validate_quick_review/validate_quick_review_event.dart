import 'package:Challet/models/feed_info_model.dart';
import 'package:Challet/models/review_model.dart';
import 'package:equatable/equatable.dart';

abstract class ValidateQuickReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateQuickReview extends ValidateQuickReviewEvent {
  final double rating;
  final String describtion;
  final ReviewModel review;
  final FeedInfoModel feedInfo;
  ValidateQuickReview(this.rating, this.describtion, this.review, this.feedInfo);
}

class ResetQuickReview extends ValidateQuickReviewEvent {}

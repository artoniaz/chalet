import 'package:Challet/models/review_model.dart';
import 'package:equatable/equatable.dart';

class ReviewState extends Equatable {
  ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewStateInitial extends ReviewState {}

class ReviewStateLoading extends ReviewState {}

class ReviewStateLoaded extends ReviewState {
  final List<ReviewModel> reviewList;
  final bool displayShowMoreReviewsButton;
  ReviewStateLoaded({
    required this.reviewList,
    required this.displayShowMoreReviewsButton,
  });

  @override
  List<Object> get props => [reviewList, displayShowMoreReviewsButton];
}

class ReviewStateLoadedEmpty extends ReviewState {
  final bool displayShowMoreReviewsButton;
  ReviewStateLoadedEmpty({
    required this.displayShowMoreReviewsButton,
  });

  @override
  List<Object> get props => [displayShowMoreReviewsButton];
}

class MoreReviewStateLoading extends ReviewState {}

class MoreReviewStateLoaded extends ReviewState {
  final List<ReviewModel> reviewList;
  final bool displayShowMoreReviewsButton;
  MoreReviewStateLoaded({
    required this.reviewList,
    required this.displayShowMoreReviewsButton,
  });

  @override
  List<Object> get props => [reviewList, displayShowMoreReviewsButton];
}

class ReviewStateError extends ReviewState {
  final String error;
  ReviewStateError(this.error);

  @override
  List<Object> get props => [error];
}

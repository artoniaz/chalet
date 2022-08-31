import 'package:Challet/models/review_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReviewsEvent extends ReviewEvent {
  final String chaletId;
  GetReviewsEvent(this.chaletId) : super();
}

class GetMoreReviewsForChalet extends ReviewEvent {
  final String chaletId;
  final ReviewModel lastReview;
  GetMoreReviewsForChalet(this.chaletId, this.lastReview) : super();
}

class ResetReviewBloc extends ReviewEvent {}

import 'package:equatable/equatable.dart';

class AddReviewState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddReviewStateInitial extends AddReviewState {}

class AddReviewValidateRatingsLoading extends AddReviewState {}

class AddReviewStateRequestLoading extends AddReviewState {}

class AddReviewStateQuickRating extends AddReviewState {}

class AddReviewStateQuickRatingConfirm extends AddReviewState {
  final double chaletRating;
  AddReviewStateQuickRatingConfirm({required this.chaletRating});
}

class AddReviewStateFullRatingDialog extends AddReviewState {
  final String currentReviewId;
  final double chaletRating;
  AddReviewStateFullRatingDialog(this.currentReviewId, this.chaletRating);
}

class AddReviewStateQuickRatingNotAllowed extends AddReviewState {
  final double chaletRating;
  AddReviewStateQuickRatingNotAllowed({required this.chaletRating});
}

class AddReviewStateClear extends AddReviewState {}

class AddReviewStateError extends AddReviewState {
  final String errorMessage;
  AddReviewStateError(this.errorMessage);
}

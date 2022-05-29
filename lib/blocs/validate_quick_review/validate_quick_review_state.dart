import 'package:equatable/equatable.dart';

class ValidateQuickReviewState extends Equatable {
  ValidateQuickReviewState();

  @override
  List<Object> get props => [];
}

class ValidateQuickReviewStateInitial extends ValidateQuickReviewState {}

class ValidateQuickReviewStateInvalid extends ValidateQuickReviewState {}

class ValidateQuickReviewStateValidating extends ValidateQuickReviewState {}

class ValidateQuickReviewStateValid extends ValidateQuickReviewState {}

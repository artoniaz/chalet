import 'package:chalet/models/feed_info_model.dart';
import 'package:equatable/equatable.dart';

class TeamFeedInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TeamFeedInfoStateInitial extends TeamFeedInfoState {}

class TeamFeedInfoStateLoading extends TeamFeedInfoState {}

class TeamFeedInfoStateLoaded extends TeamFeedInfoState {
  final List<FeedInfoModel> feedInfoList;
  TeamFeedInfoStateLoaded({required this.feedInfoList});

  @override
  List<Object> get props => [feedInfoList];
}

class TeamFeedInfoStateCreated extends TeamFeedInfoState {}

class TeamFeedInfoStateError extends TeamFeedInfoState {
  final String errorMessage;
  TeamFeedInfoStateError({required this.errorMessage});
}

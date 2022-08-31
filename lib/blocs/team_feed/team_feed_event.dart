import 'package:Challet/models/feed_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class TeamFeedInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTeamFeedInfos extends TeamFeedInfoEvent {
  final String teamId;
  GetTeamFeedInfos(this.teamId);
}

class UpdateTeamFeedInfos extends TeamFeedInfoEvent {
  final List<FeedInfoModel> feedInfoList;
  UpdateTeamFeedInfos(this.feedInfoList);

  @override
  List<Object> get props => [feedInfoList];
}

class CreateTeamFeedInfo extends TeamFeedInfoEvent {
  final FeedInfoModel feedInfo;
  CreateTeamFeedInfo(this.feedInfo);
}

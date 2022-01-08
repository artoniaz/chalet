import 'package:chalet/models/feed_display_info_model.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/services/team_feed_info_service.dart';

class TeamFeedInfoRepository {
  final _teamFeedInfoService = TeamFeedInfoService();

  Future<String> createTeamFeedInfo(FeedInfoModel feedInfo) => _teamFeedInfoService.createTeamFeedInfo(feedInfo);
  Stream<List<FeedInfoModel>> getFeedInfos(String teamId) => _teamFeedInfoService.getFeedInfos(teamId);
  Future<void> sendCongratsToFeed(FeedInfoModel feedInfo, CongratsSenderModel congratsSenderModel) =>
      _teamFeedInfoService.sendCongratsToFeed(feedInfo, congratsSenderModel);
}

enum FeedInfoRole {
  rating,
}

List<FeedDisplayInfoModel> feedDisplayInfoModelList = List<FeedDisplayInfoModel>.from([
  FeedDisplayInfoModel(
    feedInfoRole: FeedInfoRole.rating,
    feedDescription: 'Wysrał się w kiblu',
  ),
]).toList();

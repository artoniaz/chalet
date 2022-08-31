import 'package:Challet/models/achievement_model.dart';
import 'package:Challet/models/feed_display_info_model.dart';
import 'package:Challet/models/feed_info_model.dart';
import 'package:Challet/services/team_feed_info_service.dart';

class TeamFeedInfoRepository {
  final _teamFeedInfoService = TeamFeedInfoService();

  Future<String> createTeamFeedInfo(FeedInfoModel feedInfo) => _teamFeedInfoService.createTeamFeedInfo(feedInfo);
  Stream<List<FeedInfoModel>> getFeedInfos(String teamId) => _teamFeedInfoService.getFeedInfos(teamId);
  Future<void> sendCongratsToFeed(FeedInfoModel feedInfo, CongratsSenderModel congratsSenderModel) =>
      _teamFeedInfoService.sendCongratsToFeed(feedInfo, congratsSenderModel);
}

enum FeedInfoEvent {
  rating,
  addChalet,
  newMember,
  memberNewAchievement,
}

class AchievementIds {
  static AchievementModel TRAVELLER = AchievementModel(
    achievementId: 'traveller',
    achievementDescribtion: 'Obieżyświat',
  );
  static AchievementModel SITTING_KING = AchievementModel(
    achievementId: 'sittingKing',
    achievementDescribtion: 'Siedzący król',
  );
}

List<FeedDisplayInfoModel> feedDisplayInfoModelList = List<FeedDisplayInfoModel>.from([
  FeedDisplayInfoModel(
    feedInfoRole: FeedInfoEvent.rating,
    feedDescription: 'Zameldował się w Szalecie',
  ),
  FeedDisplayInfoModel(
    feedInfoRole: FeedInfoEvent.addChalet,
    feedDescription: 'Dodał Szalet',
  ),
  FeedDisplayInfoModel(
    feedInfoRole: FeedInfoEvent.newMember,
    feedDescription: 'Nowy członek klanu',
  ),
  FeedDisplayInfoModel(
    feedInfoRole: FeedInfoEvent.memberNewAchievement,
    feedDescription: 'Zdobył osiągnięcie',
  ),
]).toList();

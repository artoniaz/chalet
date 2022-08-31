import 'package:Challet/models/feed_display_info_model.dart';
import 'package:Challet/models/feed_info_model.dart';
import 'package:Challet/repositories/team_feed_info_repository.dart';

FeedDisplayInfoModel getFeedDisplayInfoModel(FeedInfoEvent feedInfoRole) =>
    feedDisplayInfoModelList.firstWhere((el) => el.feedInfoRole == feedInfoRole);

String getFeedDisplayAdditionalDescInfo(FeedInfoModel feedInfo) {
  if (feedInfo.role == FeedInfoEvent.memberNewAchievement) {
    if (feedInfo.achievementId == AchievementIds.TRAVELLER.achievementId) {
      return AchievementIds.TRAVELLER.achievementDescribtion;
    } else if (feedInfo.achievementId == AchievementIds.SITTING_KING.achievementId) {
      return AchievementIds.SITTING_KING.achievementDescribtion;
    }
    return '';
  } else if (feedInfo.role == FeedInfoEvent.addChalet || feedInfo.role == FeedInfoEvent.rating) {
    return feedInfo.chaletName;
  } else
    return '';
}

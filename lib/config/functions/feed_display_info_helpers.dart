import 'package:chalet/models/feed_display_info_model.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';

FeedDisplayInfoModel getFeedDisplayInfoModel(FeedInfoRole feedInfoRole) =>
    feedDisplayInfoModelList.firstWhere((el) => el.feedInfoRole == feedInfoRole);

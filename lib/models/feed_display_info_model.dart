import 'package:chalet/repositories/team_feed_info_repository.dart';

class FeedDisplayInfoModel {
  final FeedInfoRole feedInfoRole;
  final String feedDescription;

  FeedDisplayInfoModel({
    required this.feedInfoRole,
    required this.feedDescription,
  });
}

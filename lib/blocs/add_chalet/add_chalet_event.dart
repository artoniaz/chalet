import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';

abstract class AddChaletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateChalet extends AddChaletEvent {
  final ChaletModel chalet;
  final List<ImageModelFile> images;
  final FeedInfoModel? feedInfo;
  CreateChalet(this.chalet, this.images, this.feedInfo);

  @override
  List<Object> get props => [chalet, images];
}

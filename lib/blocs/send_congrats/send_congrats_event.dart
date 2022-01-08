import 'package:chalet/models/feed_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class SendCongratsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendCongrats extends SendCongratsEvent {
  final FeedInfoModel feedInfo;
  final CongratsSenderModel congratsSender;
  SendCongrats(this.feedInfo, this.congratsSender);
}

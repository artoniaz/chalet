import 'package:Challet/models/feed_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReactToPendingInvitationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AcceptPendingInvitation extends ReactToPendingInvitationEvent {
  final String userId;
  final String teamId;
  final String? otherTeamId;
  final double choosenColor;
  final String? previousTeamId;
  final double? previousTeamColor;
  final FeedInfoModel? feedInfo;
  AcceptPendingInvitation(
    this.userId,
    this.teamId,
    this.otherTeamId,
    this.choosenColor,
    this.previousTeamId,
    this.previousTeamColor,
    this.feedInfo,
  );
}

class DeclinePendingInvitation extends ReactToPendingInvitationEvent {
  final String declinedTeamId;
  final String userId;
  DeclinePendingInvitation(this.declinedTeamId, this.userId);
}

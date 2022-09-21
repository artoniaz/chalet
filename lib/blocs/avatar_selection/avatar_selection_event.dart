import 'package:equatable/equatable.dart';

abstract class AvatarSelectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateUserAvatarId extends AvatarSelectionEvent {
  final String userId;
  final String avatarId;
  UpdateUserAvatarId(this.userId, this.avatarId);

  @override
  List<Object> get props => [userId, avatarId];
}

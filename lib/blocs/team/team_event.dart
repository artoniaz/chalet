import 'package:equatable/equatable.dart';

abstract class TeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetTeamBloc extends TeamEvent {}

class GetTeamEvent extends TeamEvent {
  final String teamId;
  GetTeamEvent(this.teamId);
}

class UpdateTeamStats extends TeamEvent {
  final int chaletAddedNumber;
  final int chaletReviewsNumber;
  UpdateTeamStats(this.chaletAddedNumber, this.chaletReviewsNumber);
}

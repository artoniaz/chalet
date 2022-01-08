import 'package:equatable/equatable.dart';

abstract class TeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetTeamBloc extends TeamEvent {}

class AddTeamEvent extends TeamEvent {
  final String teamName;
  final String userId;
  final String userName;
  AddTeamEvent(this.userId, this.userName, this.teamName);
}

import 'package:equatable/equatable.dart';

abstract class CreateTeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetCreateTeamBloc extends CreateTeamEvent {}

class AddCreateTeamEvent extends CreateTeamEvent {
  final String teamName;
  final String userId;
  final String userName;
  AddCreateTeamEvent(this.userId, this.userName, this.teamName);
}

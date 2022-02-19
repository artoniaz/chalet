import 'package:chalet/models/index.dart';
import 'package:chalet/models/team_model.dart';
import 'package:equatable/equatable.dart';

class TeamState extends Equatable {
  TeamState();

  @override
  List<Object> get props => [];
}

class TeamStateInitial extends TeamState {}

class TeamStateLoading extends TeamState {}

class TeamStateTeamCreated extends TeamState {}

class TeamStateTeamLoaded extends TeamState {
  final TeamModel team;
  TeamStateTeamLoaded({required this.team});
  @override
  List<Object> get props => [team];
}

class TeamStateError extends TeamState {
  final String errorMessage;
  TeamStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

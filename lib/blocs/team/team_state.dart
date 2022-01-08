import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';

class TeamState extends Equatable {
  TeamState();

  @override
  List<Object> get props => [];
}

class TeamStateInitial extends TeamState {}

class TeamStateLoading extends TeamState {}

class TeamStateTeamCreated extends TeamState {}

class TeamStateError extends TeamState {
  final String errorMessage;
  TeamStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

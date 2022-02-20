import 'package:equatable/equatable.dart';

class CreateTeamState extends Equatable {
  CreateTeamState();

  @override
  List<Object> get props => [];
}

class CreateTeamStateInitial extends CreateTeamState {}

class CreateTeamStateLoading extends CreateTeamState {}

class CreateTeamStateTeamCreated extends CreateTeamState {}

class CreateTeamStateError extends CreateTeamState {
  final String errorMessage;
  CreateTeamStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

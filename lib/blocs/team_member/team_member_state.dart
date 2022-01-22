import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';

class TeamMemberState extends Equatable {
  TeamMemberState();

  @override
  List<Object> get props => [];
}

class TeamMemberStateInitial extends TeamMemberState {}

class TeamMemberStateLoading extends TeamMemberState {}

class TeamMemberStateUserFound extends TeamMemberState {
  final UserModel userLookedFor;
  TeamMemberStateUserFound({required this.userLookedFor});
  @override
  List<Object> get props => [userLookedFor];
}

class TeamMemberStateError extends TeamMemberState {
  final String errorMessage;
  TeamMemberStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

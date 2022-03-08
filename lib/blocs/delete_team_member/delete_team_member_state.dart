import 'package:equatable/equatable.dart';

class DeleteTeamMemberState extends Equatable {
  DeleteTeamMemberState();

  @override
  List<Object> get props => [];
}

class DeleteTeamMemberStateInitial extends DeleteTeamMemberState {}

class DeleteTeamMemberStateLoading extends DeleteTeamMemberState {}

class DeleteTeamMemberStateDeleted extends DeleteTeamMemberState {}

class DeleteTeamMemberStateError extends DeleteTeamMemberState {
  final String errorMessage;
  DeleteTeamMemberStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

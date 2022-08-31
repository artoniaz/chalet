import 'package:Challet/models/user_model.dart';
import 'package:equatable/equatable.dart';

class TeamMembersState extends Equatable {
  TeamMembersState();

  @override
  List<Object> get props => [];
}

class TeamMembersStateInitial extends TeamMembersState {}

class TeamMembersStateLoading extends TeamMembersState {}

class TeamMembersStateLoaded extends TeamMembersState {
  final List<UserModel> teamMemberList;
  TeamMembersStateLoaded({required this.teamMemberList});
}

class TeamMembersStateError extends TeamMembersState {
  final String errorMessage;
  TeamMembersStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

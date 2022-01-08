import 'package:equatable/equatable.dart';

abstract class TeamMemberEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetTeamMemberBloc extends TeamMemberEvent {}

class SearchMemberToTeamEvent extends TeamMemberEvent {
  final String searchedUserEmail;
  SearchMemberToTeamEvent(this.searchedUserEmail);
}

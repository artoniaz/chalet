import 'package:Challet/models/user_model.dart';
import 'package:equatable/equatable.dart';

class UserDataState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserDataStateInitial extends UserDataState {}

class UserDataStateLoading extends UserDataState {}

class UserDataStateLoaded extends UserDataState {
  final UserModel user;
  UserDataStateLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserDataStateCreated extends UserDataState {}

class UserDataStateError extends UserDataState {
  final String errorMessage;
  UserDataStateError({required this.errorMessage});
}

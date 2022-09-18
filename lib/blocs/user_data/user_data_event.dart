import 'package:chalet/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserDataInitialState extends UserDataEvent {}

class GetUserData extends UserDataEvent {
  final String userId;
  GetUserData(this.userId);
}

class UpdateUserData extends UserDataEvent {
  final UserModel user;
  UpdateUserData(this.user);

  @override
  List<Object> get props => [user];
}

class CreateUserData extends UserDataEvent {
  final String userId;
  final UserModel user;
  CreateUserData(this.userId, this.user);
}

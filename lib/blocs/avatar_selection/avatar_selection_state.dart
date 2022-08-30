import 'package:equatable/equatable.dart';

class AvatarSelectionState extends Equatable {
  @override
  List<Object> get props => [];
}

class AvatarSelectionStateInitial extends AvatarSelectionState {}

class AvatarSelectionStateLoading extends AvatarSelectionState {}

class AvatarSelectionStateUpdated extends AvatarSelectionState {
  AvatarSelectionStateUpdated();

  @override
  List<Object> get props => [];
}

class AvatarSelectionStateError extends AvatarSelectionState {
  final String errorMessage;
  AvatarSelectionStateError({required this.errorMessage});
}

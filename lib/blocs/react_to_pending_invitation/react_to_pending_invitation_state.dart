import 'package:equatable/equatable.dart';

class ReactToPendingInvitationState extends Equatable {
  ReactToPendingInvitationState();

  @override
  List<Object> get props => [];
}

class ReactToPendingInvitationStateInitial extends ReactToPendingInvitationState {}

class ReactToPendingInvitationStateLoading extends ReactToPendingInvitationState {}

class ReactToPendingInvitationStateAccepted extends ReactToPendingInvitationState {}

class ReactToPendingInvitationStateDeclined extends ReactToPendingInvitationState {}

class ReactToPendingInvitationStateError extends ReactToPendingInvitationState {
  final String errorMessage;
  ReactToPendingInvitationStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

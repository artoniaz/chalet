import 'package:equatable/equatable.dart';

class SendCongratsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SendCongratsStateInitial extends SendCongratsState {}

class SendCongratsStateLoading extends SendCongratsState {}

class SendCongratsStateLoaded extends SendCongratsState {
  @override
  List<Object> get props => [];
}

class SendCongratsStateError extends SendCongratsState {
  final String errorMessage;
  SendCongratsStateError({required this.errorMessage});
}

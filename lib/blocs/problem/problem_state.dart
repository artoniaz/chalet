import 'package:equatable/equatable.dart';

class ProblemState extends Equatable {
  ProblemState();

  @override
  List<Object> get props => [];
}

class ProblemStateInitial extends ProblemState {}

class ProblemStateLoading extends ProblemState {}

class ProblemStateLoaded extends ProblemState {}

class ProblemStateError extends ProblemState {
  final String errorMessage;
  ProblemStateError(this.errorMessage);
}

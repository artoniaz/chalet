import 'package:Challet/models/problem_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProblemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateProblem extends ProblemEvent {
  final ProblemModel problem;
  CreateProblem(this.problem);
}

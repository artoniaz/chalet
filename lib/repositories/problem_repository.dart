import 'package:chalet/models/problem_model.dart';
import 'package:chalet/services/problem_service.dart';

class ProblemRepository {
  final _problemService = ProblemService();

  Future<String> createProblem(ProblemModel problem) => _problemService.createProblem(problem);
}

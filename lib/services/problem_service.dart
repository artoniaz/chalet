import 'package:Challet/models/problem_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemService {
  final CollectionReference problemCollection = FirebaseFirestore.instance.collection("problems");

  Future<String> createProblem(ProblemModel problem) async {
    try {
      DocumentReference<Object?> res = await problemCollection.add(problem.toJson());
      return res.id;
    } catch (e) {
      print(e);
      throw 'Blad zapisu zgłoszenia';
    }
  }
}

import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/team_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  final CollectionReference _teamsCollection = FirebaseFirestore.instance.collection("teams");

  Future<List<TeamMemberModel>> getTeamMemberList(String teamId) async {
    try {
      final data = await _teamsCollection.doc(teamId).collection('members').orderBy('isAdmin', descending: true).get();
      return data.docs.map((doc) => TeamMemberModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o członkach klanu';
    }
  }

  Future<List<TeamMemberModel>> getPendingTeamMemberList(String teamId) async {
    try {
      final data = await _teamsCollection.doc(teamId).collection('pendingMembers').get();
      return data.docs.map((doc) => TeamMemberModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o oczekujących zaproszeniach';
    }
  }

  Future<String> createTeam(String userId, String userName, String teamName) async {
    try {
      DocumentReference<Object?> res = await _teamsCollection.add(TeamModel(id: '', name: teamName).toJson());
      _teamsCollection
          .doc(res.id)
          .collection("members")
          .doc(userId)
          .set(TeamMemberModel(id: userId, name: userName, isAdmin: true).toJson());
      return res.id;
    } catch (e) {
      throw 'Nie udało się dodać klanu';
    }
  }

  Future<void> createPendingTeamMember(String pendingUserId, String userName, String teamId) async {
    try {
      await _teamsCollection
          .doc(teamId)
          .collection('pendingMembers')
          .doc(pendingUserId)
          .set(TeamMemberModel(id: pendingUserId, name: userName, isAdmin: false).toJson());
    } catch (e) {
      throw 'Nie udało się wysłać zaposzenia użytkownikowi';
    }
  }
}

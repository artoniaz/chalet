import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/team_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  final CollectionReference _teamsCollection = FirebaseFirestore.instance.collection("teams");
  final String PENDING_MEMBERS = 'pendingMembers';
  final String MEMBERS = 'members';

  Future<List<TeamMemberModel>> getTeamMemberList(String teamId) async {
    try {
      final data = await _teamsCollection.doc(teamId).collection(MEMBERS).orderBy('isAdmin', descending: true).get();
      return data.docs.map((doc) => TeamMemberModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o członkach klanu';
    }
  }

  Future<List<TeamMemberModel>> getPendingTeamMemberList(String teamId) async {
    try {
      final data = await _teamsCollection.doc(teamId).collection(PENDING_MEMBERS).get();
      return data.docs.map((doc) => TeamMemberModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o oczekujących zaproszeniach';
    }
  }

  Future<String> createTeam(String userId, String userName, String teamName) async {
    try {
      DocumentReference<Object?> res =
          await _teamsCollection.add(TeamModel(id: '', name: teamName, teamAdminId: userId).toJson());
      _teamsCollection
          .doc(res.id)
          .collection(MEMBERS)
          .doc(userId)
          .set(TeamMemberModel(id: userId, name: userName, isAdmin: true, teamName: teamName, teamId: res.id).toJson());
      return res.id;
    } catch (e) {
      throw 'Nie udało się dodać klanu';
    }
  }

  Future<void> createPendingTeamMember(TeamMemberModel teamMemberModel) async {
    try {
      await _teamsCollection
          .doc(teamMemberModel.teamId)
          .collection(PENDING_MEMBERS)
          .doc(teamMemberModel.id)
          .set(teamMemberModel.toJson());
    } catch (e) {
      throw 'Nie udało się wysłać zaposzenia użytkownikowi';
    }
  }

  Future<void> deleteTeamMember(String userToDeleteId, String teamId) async {
    try {
      await _teamsCollection.doc(teamId).collection(MEMBERS).doc(userToDeleteId).delete();
    } catch (e) {
      throw 'Nie udało się usunąć użytkownika z klanu';
    }
  }

  Future<void> acceptInvitation(TeamMemberModel teamMember, String? otherTeamId) async {
    try {
      List<Future> futures = [
        _teamsCollection.doc(teamMember.teamId).collection(MEMBERS).doc(teamMember.id).set(teamMember.toJson()),
        _teamsCollection.doc(teamMember.teamId).collection(PENDING_MEMBERS).doc(teamMember.id).delete(),
        if (otherTeamId != null)
          _teamsCollection.doc(otherTeamId).collection(PENDING_MEMBERS).doc(teamMember.id).delete(),
      ];
      await Future.wait(futures);
    } catch (e) {
      throw 'Nie udało się zaakceptować zaproszenia. Spróbuj ponownie';
    }
  }

  Future<void> declineInvitation(String teamToDeclineId, String decliningUserId) async {
    try {
      await _teamsCollection.doc(teamToDeclineId).collection(PENDING_MEMBERS).doc(decliningUserId).delete();
    } catch (e) {
      throw 'Nie udało się odrzucić zaproszenia';
    }
  }
}

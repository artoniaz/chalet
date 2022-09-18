import 'package:chalet/models/index.dart';
import 'package:chalet/models/team_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  final CollectionReference _teamsCollection = FirebaseFirestore.instance.collection("teams");
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection("users");

  final String PENDING_MEMBERS = 'pendingMembers';
  final String MEMBERS = 'members';
  final String PENDING_MEMBERS_IDS = 'pendingMembersIds';
  final String MEMBERS_IDS = 'membersIds';
  final String CHOOSEN_COLORS = 'choosenColors';

  Future<TeamModel> getTeam(String teamId) async {
    try {
      final team = await _teamsCollection.doc(teamId).get();
      return TeamModel.fromJson(team, team.id);
    } catch (e) {
      throw 'Błąd pobierania informacji o klanie';
    }
  }

  Future<List<UserModel>> getTeamMembers(List<String> teamMembersId) async {
    try {
      var data = await _usersCollection.where('uid', whereIn: teamMembersId).get();
      return data.docs.map((el) => UserModel.fromJson(el)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o członkach klanu';
    }
  }

  Future<List<UserModel>> getPendingTeamMembers(List<String> pendingTeamMembersId) async {
    try {
      if (pendingTeamMembersId.isEmpty) return [];
      var data = await _usersCollection.where('uid', whereIn: pendingTeamMembersId).limit(10).get();
      return data.docs.map((el) => UserModel.fromJson(el)).toList();
    } catch (e) {
      throw 'Błąd pobierania informacji o oczekujących zaproszeniach';
    }
  }

  Future<String> createTeam(String userId, String userName, String teamName, double choosenColor) async {
    try {
      DocumentReference<Object?> res = await _teamsCollection.add(
        TeamModel(
          id: '',
          name: teamName,
          teamAdminId: userId,
          teamAdminName: userName,
          membersIds: [userId],
          choosenColors: [choosenColor],
          pendingMembersIds: [],
          created: Timestamp.now(),
        ).toJson(),
      );
      return res.id;
    } catch (e) {
      throw 'Nie udało się dodać klanu';
    }
  }

  Future<void> createPendingTeamMember(String teamId, String pendingMemberId) async {
    try {
      await _teamsCollection.doc(teamId).update({
        'pendingMembersIds': FieldValue.arrayUnion([pendingMemberId]),
      });
    } catch (e) {
      throw 'Nie udało się wysłać zaposzenia użytkownikowi';
    }
  }

  Future<void> deleteTeamMember(String teamId, String userToDeleteId, double choosenColor) async {
    try {
      await _teamsCollection.doc(teamId).update({
        MEMBERS_IDS: FieldValue.arrayRemove([userToDeleteId]),
        CHOOSEN_COLORS: FieldValue.arrayRemove([choosenColor]),
      });
    } catch (e) {
      throw 'Nie udało się usunąć użytkownika z klanu';
    }
  }

  Future<void> acceptInvitation(String teamId, String userId, String? otherTeamId, double choosenColor) async {
    try {
      await _teamsCollection.doc(teamId).update({
        MEMBERS_IDS: FieldValue.arrayUnion([userId]),
        CHOOSEN_COLORS: FieldValue.arrayUnion([choosenColor]),
        PENDING_MEMBERS_IDS: FieldValue.arrayRemove([userId]),
      });
      if (otherTeamId != null)
        _teamsCollection.doc(otherTeamId).update({
          PENDING_MEMBERS_IDS: FieldValue.arrayRemove([userId]),
        });
    } catch (e) {
      throw 'Nie udało się zaakceptować zaproszenia. Spróbuj ponownie';
    }
  }

  Future<void> declineInvitation(String teamToDeclineId, String decliningUserId) async {
    try {
      await _teamsCollection.doc(teamToDeclineId).update({
        PENDING_MEMBERS_IDS: FieldValue.arrayRemove([decliningUserId]),
      });
    } catch (e) {
      throw 'Nie udało się odrzucić zaproszenia';
    }
  }
}

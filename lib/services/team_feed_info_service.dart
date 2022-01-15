import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamFeedInfoService implements TeamFeedInfoRepository {
  final CollectionReference _teamsCollection = FirebaseFirestore.instance.collection('teams');
  final String FEED_INFOS = 'feedInfos';

  @override
  Stream<List<FeedInfoModel>> getFeedInfos(String teamId) {
    return _teamsCollection
        .doc(teamId)
        .collection(FEED_INFOS)
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FeedInfoModel.fromJson(doc, doc.id)).toList());
  }

  @override
  Future<String> createTeamFeedInfo(FeedInfoModel feedInfo) async {
    try {
      DocumentReference<Object>? res =
          await _teamsCollection.doc(feedInfo.teamId).collection(FEED_INFOS).add(feedInfo.toJson());
      return res.id;
    } catch (e) {
      throw 'Błąd dodawania informacji dla klanu';
    }
  }

  Future<void> sendCongratsToFeed(FeedInfoModel feedInfo, CongratsSenderModel congratsSenderModel) async {
    try {
      await _teamsCollection.doc(feedInfo.teamId).collection(FEED_INFOS).doc(feedInfo.id).update({
        'congratsSentNumber': FieldValue.increment(1),
        'congratsSenderList': FieldValue.arrayUnion([congratsSenderModel.toJson()])
      });
    } catch (e) {
      throw 'Błąd wysyłania gratulacji. Spróbuj ponownie';
    }
  }
}

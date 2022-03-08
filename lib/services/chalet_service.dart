import 'dart:async';

import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ChaletService {
  // collection reference
  final CollectionReference chaletCollection = FirebaseFirestore.instance.collection("chalets");

  Geoflutterfire geo = Geoflutterfire();

  Stream<List<ChaletModel>> getChaletStream(BehaviorSubject<LatLng> subject) {
    return subject.switchMap((center) {
      return geo
          .collection(collectionRef: chaletCollection)
          .within(center: getGeoFirePointFromLatLng(center), radius: 0.2, field: 'position', strictMode: true);
    }).map((documentSnapshotList) => documentSnapshotList
        .map((documentSnapshot) => ChaletModel.fromJson(documentSnapshot.data(), documentSnapshot.id))
        .toList());
  }

  Future<List<ChaletModel>>? getChaletList({ChaletModel? lastChalet, GeoFirePoint? center}) async {
    final data = lastChalet == null
        ? await chaletCollection.orderBy('rating', descending: true).limit(1).get()
        : await chaletCollection
            // .where('rating', isGreaterThan: 4)
            .orderBy('rating', descending: true)
            .startAfter([lastChalet.rating])
            .limit(1)
            .get();
    return data.docs.map((doc) => ChaletModel.fromJson(doc.data(), doc.id)).toList();
  }

  Future<String?> createChalet(ChaletModel chalet) async {
    try {
      DocumentReference<Object?> res = await chaletCollection.add(chalet.toJson());
      return res.id;
    } catch (e) {
      print(e);
      throw 'Blad zapisu szaletu';
    }
  }

  Future<void> updateChaletImages(String chaletId, List<ImageModelUrl> imageUrlList) async {
    try {
      List<Map<String, dynamic>> imagesJson = imageUrlList.map<Map<String, dynamic>>((el) => el.toJson()).toList();
      chaletCollection.doc(chaletId).update({'images': imagesJson});
    } catch (e) {
      print(e);
      throw 'Blad zapisu zdjec';
    }
  }

  Future<void> updateImageDefaultInfo() async {}

  Stream<List<ChaletModel>> getChaletListAddedByUsers(List<String> teamMembersIds) {
    return chaletCollection
        .where('creatorId', whereIn: teamMembersIds)
        .limit(8)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChaletModel.fromJson(doc, doc.id)).toList());
  }
}

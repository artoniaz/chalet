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

  StreamSubscription<List<ChaletModel>> getChaletStream(
      BehaviorSubject<LatLng> subject, void Function(List<ChaletModel>) updateMarkers) {
    return subject
        .switchMap((center) {
          return geo
              .collection(collectionRef: chaletCollection)
              .within(center: getGeoFirePointFromLatLng(center), radius: 50.0, field: 'position', strictMode: true);
        })
        .map((documentSnapshotList) => documentSnapshotList
            .map((documentSnapshot) => ChaletModel.fromJson(documentSnapshot.data() as Map<String, dynamic>))
            .toList())
        .listen(updateMarkers);
  }

  Future<List<ChaletModel>>? getChaletList({ChaletModel? lastChalet, GeoFirePoint? center}) {
    final data = lastChalet == null
        ? chaletCollection.orderBy('rating', descending: true).limit(1).get()
        : chaletCollection
            // .where('rating', isGreaterThan: 4)
            .orderBy('rating', descending: true)
            .startAfter([lastChalet.rating])
            .limit(1)
            .get();
    return data.then((snapshot) => snapshot.docs
        .map((doc) => ChaletModel(
            // id: (doc.data() as dynamic)['id'] ?? '',
            name: (doc.data() as dynamic)['name'] ?? '',
            rating: (doc.data() as dynamic)['rating'].toDouble() ?? 0.0,
            quality: (doc.data() as dynamic)['quality']?.toDouble() ?? 0.0,
            clean: (doc.data() as dynamic)['clean']?.toDouble() ?? 0.0,
            paper: (doc.data() as dynamic)['paper']?.toDouble() ?? 0.0,
            privacy: (doc.data() as dynamic)['privacy']?.toDouble() ?? 0.0,
            position: (doc.data() as dynamic)['position'] ?? GeoFirePoint(0, 0),
            images: List<ImageModelUrl>.from(
              (doc.data() as dynamic)["images"].map((item) {
                return new ImageModelUrl(
                    imageUrlOriginalSize: item['imageUrlOriginalSize'] ?? '',
                    imageUrlMinSize: item['imageUrlMinSize'] ?? '',
                    isDefault: item['isDefault'] ?? false);
              }),
            ),
            description: (doc.data() as dynamic)['description'] ?? ''))
        .toList());
  }

  Future<String?> createChalet(ChaletModel chalet) async {
    try {
      DocumentReference<Object?> res = await chaletCollection.add({
        'name': chalet.name,
        'rating': chalet.rating,
        'quality': chalet.quality,
        'clean': chalet.clean,
        'paper': chalet.paper,
        'privacy': chalet.privacy,
        'description': chalet.description,
        'position': chalet.position.data,
      });
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
}

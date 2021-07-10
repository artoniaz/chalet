import 'dart:convert';

import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChaletService {
  // collection reference
  final CollectionReference chaletCollection = FirebaseFirestore.instance.collection("chalets");

  // chalet list from snapshot
  List<ChaletModel> _chaletListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => ChaletModel(
            id: (doc.data() as dynamic)['id'] ?? '',
            name: (doc.data() as dynamic)['name'] ?? '',
            rating: (doc.data() as dynamic)['rating'].toDouble() ?? 0.0,
            quality: (doc.data() as dynamic)['quality'].toDouble() ?? 0.0,
            clean: (doc.data() as dynamic)['clean'].toDouble() ?? 0.0,
            paper: (doc.data() as dynamic)['paper'].toDouble() ?? 0.0,
            privacy: (doc.data() as dynamic)['privacy'].toDouble() ?? 0.0,
            images: (doc.data() as dynamic)['images'].toList() ?? [],
            description: (doc.data() as dynamic)['description'] ?? ''))
        .toList();
  }

  // get chalet stream
  Stream<List<ChaletModel>> get chalets {
    return chaletCollection.snapshots().map(_chaletListFromSnapshot);
  }

  // get chalet paginated list
  Future<List<ChaletModel>>? getChaletList(ChaletModel? lastChalet) {
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
            id: (doc.data() as dynamic)['id'] ?? '',
            name: (doc.data() as dynamic)['name'] ?? '',
            rating: (doc.data() as dynamic)['rating'].toDouble() ?? 0.0,
            quality: (doc.data() as dynamic)['quality']?.toDouble() ?? 0.0,
            clean: (doc.data() as dynamic)['clean']?.toDouble() ?? 0.0,
            paper: (doc.data() as dynamic)['paper']?.toDouble() ?? 0.0,
            privacy: (doc.data() as dynamic)['privacy']?.toDouble() ?? 0.0,
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

import 'dart:io';

import 'package:Challet/models/index.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final String chaletUid;
  CloudStorageService({required this.chaletUid});

  Reference storageReference = FirebaseStorage.instance.ref();

  Reference get imgRef => FirebaseStorage.instance.ref().child('test_toilet1.jpg');

  Future<List<String>> getImagesUrlsForChalet() async {
    List<String> imgsUrls = [];
    final imgListRef = await storageReference.child(chaletUid).list();
    imgListRef.items.forEach((item) async => imgsUrls.add(await item.getDownloadURL()));
    return imgsUrls;
  }

  Future<CloudStorageResultModel?> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    final imageFileName = title + DateTime.now().millisecondsSinceEpoch.toString();

    //get the reference to the file we want to create
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    TaskSnapshot storageSnapshot = uploadTask.snapshot;

    final downloadUrl = await storageSnapshot.ref.getDownloadURL();
    uploadTask.whenComplete(() {
      String url = downloadUrl.toString();
      return CloudStorageResultModel(imageUrl: url, imageFileName: imageFileName);
    });
    return null;
  }
}

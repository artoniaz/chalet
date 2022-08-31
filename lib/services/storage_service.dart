import 'dart:io';

import 'package:Challet/models/image_model_file.dart';
import 'package:Challet/models/image_model_url.dart';
import 'package:Challet/services/chalet_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class StorageService {
  Reference storageRef = FirebaseStorage.instance.ref();
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;

  Future<List<ImageModelUrl>> addImagesToStorage(String chaletId, List<ImageModelFile> imageFileList) async {
    try {
      Future<List<ImageModelUrl>> addImages() async {
        List<ImageModelUrl> imagesUrlList = [];

        for (var el in imageFileList) {
          // File imageMinFile = await FlutterNativeImage.compressImage(
          //   el.imageFile.path,
          //   quality: 100,
          //   percentage: 50,
          // );
          int imgIndex = imageFileList.indexOf(el);
          TaskSnapshot uploadOriginalImageTask = await storageRef
              .child('chalet_images/$chaletId/$imgIndex/chalet_${chaletId}_${imgIndex}_orignal')
              .putFile(el.imageFile);
          // TaskSnapshot uploadMinImageTask = await storageRef
          //     .child('chalet_images/$chaletId/$imgIndex/chalet_${chaletId}_${imgIndex}_min')
          //     .putFile(imageMinFile);
          // if (uploadOriginalImageTask.state == TaskState.success && uploadMinImageTask.state == TaskState.success) {
          if (uploadOriginalImageTask.state == TaskState.success) {
            final String downloadUrlOriginal = await uploadOriginalImageTask.ref.getDownloadURL();
            // final String downloadUrlMin = await uploadMinImageTask.ref.getDownloadURL();
            final image = ImageModelUrl(
              imageUrlOriginalSize: downloadUrlOriginal,
              // imageUrlMinSize: downloadUrlMin,
              isDefault: imageFileList[imgIndex].isDefault,
            );
            imagesUrlList.add(image);
          }
        }
        return imagesUrlList;
      }

      List<ImageModelUrl> images = await addImages();
      await ChaletService().updateChaletImages(chaletId, images);
      return images;
    } catch (e) {
      throw 'Blad zapisu zdjec';
    }
  }

  Future<void> editUserPhotoURL(String userUid, File imageFile) async {
    try {
      TaskSnapshot uploadImageTask = await storageRef.child('user_images/$userUid').putFile(imageFile);
      if (uploadImageTask.state == TaskState.success) {
        final String downloadUrlOriginal = await uploadImageTask.ref.getDownloadURL();
        await _firebaseAuth.currentUser!.updatePhotoURL(downloadUrlOriginal);
      }
    } catch (e) {
      print(e);
      throw 'Nie udało się zaktualizować zdjęcia profilowego';
    }
  }
}

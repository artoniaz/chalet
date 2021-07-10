import 'dart:io';

import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/services/chalet_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class StorageService {
  Reference storageRef = FirebaseStorage.instance.ref();

  Future<void> addImagesToStorage(String chaletId, List<ImageModelFile> imageFileList) async {
    try {
      Future<List<ImageModelUrl>> addImages() async {
        List<ImageModelUrl> imagesUrlList = [];

        for (var el in imageFileList) {
          File imageMinFile = await FlutterNativeImage.compressImage(
            el.imageFile.path,
            quality: 100,
            percentage: 50,
          );
          int imgIndex = imageFileList.indexOf(el);
          TaskSnapshot uploadOriginalImageTask = await storageRef
              .child('chalet_images/$chaletId/$imgIndex/chalet_${chaletId}_${imgIndex}_orignal')
              .putFile(el.imageFile);
          TaskSnapshot uploadMinImageTask = await storageRef
              .child('chalet_images/$chaletId/$imgIndex/chalet_${chaletId}_${imgIndex}_min')
              .putFile(imageMinFile);
          if (uploadOriginalImageTask.state == TaskState.success && uploadMinImageTask.state == TaskState.success) {
            final String downloadUrlOriginal = await uploadOriginalImageTask.ref.getDownloadURL();
            final String downloadUrlMin = await uploadMinImageTask.ref.getDownloadURL();
            final image = ImageModelUrl(
              imageUrlOriginalSize: downloadUrlOriginal,
              imageUrlMinSize: downloadUrlMin,
              isDefault: imageFileList[imgIndex].isDefault,
            );
            imagesUrlList.add(image);
          }
        }
        return imagesUrlList;
      }

      List<ImageModelUrl> images = await addImages();
      ChaletService().updateChaletImages(chaletId, images);
    } catch (e) {
      throw 'Blad zapisu zdjec';
    }
  }
}

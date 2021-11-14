import 'dart:io';

import 'package:chalet/models/image_model_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileListModel extends ChangeNotifier {
  final List<ImageModelFile> _images = [];

  List<ImageModelFile> get images => _images;

  void addImage(ImageModelFile img) {
    _images.add(img);
    notifyListeners();
  }

  void changeDefaultImage(int indexToChage) {
    _images.forEach((el) => el.isDefault = false);
    _images[indexToChage].isDefault = true;
    notifyListeners();
  }

  void removeImage(int indexToRemove) {
    _images.removeAt(indexToRemove);
    notifyListeners();
  }

  getImageCamera() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: '');
    final _picker = ImagePicker();
    XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 60, maxHeight: 1800, maxWidth: 1800);
    var img = ImageModelFile(
      imageFile: File(pickedImage?.path ?? ''),
      isDefault: _images.isEmpty,
    );
    if (pickedImage != null) {
      addImage(img);
      EasyLoading.dismiss();
      notifyListeners();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Nie wybrano zdjecia');
    }
  }

  getImageGallery() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: '');
    final _picker = ImagePicker();
    final List<XFile>? _imagesFromGallery = await _picker.pickMultiImage();
    List<ImageModelFile> imgs = [];
    _imagesFromGallery?.asMap().forEach((i, el) => imgs.add(ImageModelFile(
          imageFile: File(el.path),
          isDefault: i == 0,
        )));
    if (imgs.isNotEmpty) {
      imgs.forEach((el) => addImage(el));
      EasyLoading.dismiss();
      notifyListeners();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Nie wybrano zdjecia');
    }
  }
}

import 'dart:io';

import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChaletImagePicker extends StatefulWidget {
  final Function(List<File>) handleImagesChange;
  const ChaletImagePicker({Key? key, required this.handleImagesChange,}) : super(key: key);

  @override
  _ChaletImagePickerState createState() => _ChaletImagePickerState();
}

class _ChaletImagePickerState extends State<ChaletImagePicker> {

  List<File> images = [];

  Future getImage() async {
    final _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        images.add(File(pickedImage.path));
        widget.handleImagesChange(images);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimentions.pictureHeight,
      width: MediaQuery.of(context).size.width,
      color: Palette.white,
      //TODO: finish
      child: images.isEmpty ? Center(
        child: CustomElevatedButton(
          label: 'zrób zdjęcie',
          onPressed: () => getImage(),
          backgroundColor: Palette.darkBlue,
        ),
      ) : 
      Image.file(images.first, height: Dimentions.pictureHeight)
      ,
    );
  }
}

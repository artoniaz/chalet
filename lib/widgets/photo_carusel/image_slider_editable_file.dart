import 'dart:io';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ImageSliderEditFile extends StatelessWidget {
  final ImageModelFile itemFile;
  final int currentImgIndex;
  final int imageIndex;
  final Function(int) handleOnPageChaged;

  const ImageSliderEditFile({
    Key? key,
    required this.itemFile,
    required this.currentImgIndex,
    required this.imageIndex,
    required this.handleOnPageChaged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.file(
              itemFile.imageFile,
              height: Dimentions.pictureHeight,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: Dimentions.medium,
              top: Dimentions.medium,
              child: StarIcon(
                isDefault: itemFile.isDefault,
                imageIndex: imageIndex,
              ),
            ),
            Positioned(
                left: Dimentions.medium,
                top: Dimentions.medium,
                child: TrashIcon(
                  imageIndex: imageIndex,
                )),
            Positioned(
                right: Dimentions.medium,
                bottom: Dimentions.medium,
                child: AddIcon(
                  handleOnPageChaged: handleOnPageChaged,
                )),
          ],
        ));
  }
}

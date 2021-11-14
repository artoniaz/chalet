import 'dart:io';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/screens/add_chalet/image_source_bottom_sheet.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSliderEditFile extends StatelessWidget {
  final ImageModelFile itemFile;
  final int currentImgIndex;
  final int imageIndex;

  const ImageSliderEditFile({
    Key? key,
    required this.itemFile,
    required this.currentImgIndex,
    required this.imageIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ImageFileListModel imageFileList = Provider.of<ImageFileListModel>(context);

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
            // Positioned(
            //   right: Dimentions.medium,
            //   top: Dimentions.medium,
            //   child: StarIcon(
            //     isDefault: itemFile.isDefault,
            //     imageIndex: imageIndex,
            //   ),
            // ),
            Positioned(
              left: Dimentions.small,
              bottom: Dimentions.small,
              child: CustomRoundedIconButton(
                onPressed: () => imageFileList.removeImage(imageIndex),
                iconData: Icons.delete,
                iconSize: 35.0,
              ),
            ),
            Positioned(
              right: Dimentions.small,
              bottom: Dimentions.small,
              child: CustomRoundedIconButton(
                onPressed: () => imageSourceBottomSheet(
                  context,
                  handleGalleryImg: imageFileList.getImageGallery,
                  handleCameraImg: imageFileList.getImageCamera,
                ),
                iconData: Icons.add,
                iconSize: 35.0,
              ),
            ),
          ],
        ));
  }
}

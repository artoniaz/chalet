import 'package:Challet/models/image_model_file.dart';
import 'package:Challet/providers/image_file_list_provider_model.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSliderEditFile extends StatelessWidget {
  final ImageModelFile itemFile;
  final int currentImgIndex;
  final int imageIndex;
  final bool allowAddMoreImg;

  const ImageSliderEditFile({
    Key? key,
    required this.itemFile,
    required this.currentImgIndex,
    required this.imageIndex,
    required this.allowAddMoreImg,
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
            Positioned(
              left: Dimentions.small,
              bottom: Dimentions.small,
              child: CustomRoundedIconButton(
                onPressed: () => imageFileList.removeImage(imageIndex),
                iconData: Icons.delete,
                iconSize: 35.0,
              ),
            ),
            // if (allowAddMoreImg)
            //   Positioned(
            //     right: Dimentions.small,
            //     bottom: Dimentions.small,
            //     child: CustomRoundedIconButton(
            //       onPressed: () => imageSourceBottomSheet(
            //         context,
            //         handleGalleryImg: imageFileList.getImageGallery,
            //         handleCameraImg: imageFileList.getImageCamera,
            //       ),
            //       iconData: Icons.add,
            //       iconSize: 35.0,
            //     ),
            //   ),
          ],
        ));
  }
}

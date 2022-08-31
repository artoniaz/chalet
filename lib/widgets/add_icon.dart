import 'package:Challet/providers/image_file_list_provider_model.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIcon extends StatelessWidget {
  const AddIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageFileListModel imageFileList = Provider.of<ImageFileListModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: () => imageSourceBottomSheet(
          context,
          handleGalleryImg: imageFileList.getImageGallery,
          handleCameraImg: imageFileList.getImageCamera,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 2.0,
        fillColor: Palette.chaletBlue,
        child: Center(
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Palette.backgroundWhite,
          ),
        ),
        shape: CircleBorder(),
      ),
    );
  }
}

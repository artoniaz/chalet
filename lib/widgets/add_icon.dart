import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIcon extends StatelessWidget {
  final Function(int) handleOnPageChaged;
  const AddIcon({
    Key? key,
    required this.handleOnPageChaged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageFileListModel imageFileList = Provider.of<ImageFileListModel>(context);
    return IconButton(
        icon: Icon(Icons.add),
        color: Palette.goldLeaf,
        iconSize: 50.0,
        onPressed: () => imageSourceBottomSheet(
              context,
              handleGalleryImg: () {},
              handleCameraImg: () async {
                await imageFileList.getImageCamera();
                handleOnPageChaged(imageFileList.images.length - 1);
              },
            ));
  }
}

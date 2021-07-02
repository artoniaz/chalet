import 'dart:ffi';

import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrashIcon extends StatelessWidget {
  final int imageIndex;
  const TrashIcon({
    Key? key,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final handleRemoveImage = Provider.of<ImageFileListModel>(context, listen: false).removeImage;

    return IconButton(
      icon: Icon(Icons.delete),
      color: Palette.goldLeaf,
      iconSize: 50.0,
      onPressed: () => handleRemoveImage(imageIndex),
    );
  }
}

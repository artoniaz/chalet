import 'package:Challet/providers/image_file_list_provider_model.dart';
import 'package:Challet/styles/index.dart';
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        constraints: BoxConstraints(minWidth: 50),
        onPressed: () => handleRemoveImage(imageIndex),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 2.0,
        fillColor: Palette.chaletBlue,
        child: Center(
          child: Icon(
            Icons.delete,
            size: 20.0,
            color: Palette.backgroundWhite,
          ),
        ),
        shape: CircleBorder(),
      ),
    );
  }
}

import 'package:Challet/providers/image_file_list_provider_model.dart';
import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StarIcon extends StatelessWidget {
  final bool isDefault;
  final int imageIndex;
  const StarIcon({
    Key? key,
    required this.isDefault,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final handleChangeDefaultImage = Provider.of<ImageFileListModel>(context).changeDefaultImage;
    return IconButton(
      onPressed: () => handleChangeDefaultImage(imageIndex),
      icon: isDefault ? Icon(Icons.star) : Icon(Icons.star_border),
      color: Palette.goldLeaf,
      iconSize: 50.0,
    );
  }
}

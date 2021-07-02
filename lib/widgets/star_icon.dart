import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class StarIcon extends StatelessWidget {
  final bool isDefault;
  const StarIcon({
    Key? key,
    required this.isDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      isDefault ? Icons.star : Icons.star_border,
      color: Palette.goldLeaf,
      size: 50.0,
    );
  }
}

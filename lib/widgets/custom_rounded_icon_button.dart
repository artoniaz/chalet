import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomRoundedIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;
  final double? iconSize;
  const CustomRoundedIconButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.iconSize = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(4.0),
      constraints: BoxConstraints(minWidth: 0),
      onPressed: () => onPressed(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 2.0,
      fillColor: Palette.chaletBlue,
      child: Center(
        child: Icon(
          iconData,
          size: iconSize,
          color: Palette.backgroundWhite,
        ),
      ),
      shape: CircleBorder(),
    );
  }
}

import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomElevatedButtonIcon extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final Color? backgroundColor;
  final IconData iconData;
  const CustomElevatedButtonIcon({
    Key? key,
    this.onPressed,
    required this.label,
    this.backgroundColor,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconData),
      onPressed: onPressed != null ? () => onPressed!() : null,
      style: ButtonStyle(
          splashFactory: InkSplash.splashFactory,
          backgroundColor:
              MaterialStateProperty.all(onPressed == null ? Colors.grey[400] : backgroundColor ?? Palette.goldLeaf)),
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Palette.backgroundWhite),
      ),
    );
  }
}

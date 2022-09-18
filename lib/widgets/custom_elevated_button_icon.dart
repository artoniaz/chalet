import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomElevatedButtonIcon extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final Color? backgroundColor;
  final Widget icon;
  const CustomElevatedButtonIcon(
      {Key? key, this.onPressed, required this.label, this.backgroundColor, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
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

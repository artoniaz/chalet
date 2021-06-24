import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final Color? backgroundColor;
  const CustomElevatedButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed != null ? () => onPressed!() : null,
        style: ButtonStyle(
            splashFactory: InkSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(onPressed == null
                ? Colors.grey[400]
                : backgroundColor ?? Palette.goldLeaf)),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Palette.white),
        ));
  }
}

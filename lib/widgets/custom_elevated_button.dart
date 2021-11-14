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
            elevation: MaterialStateProperty.all(0.0),
            splashFactory: InkSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(
                onPressed == null ? Colors.grey[400] : backgroundColor ?? Palette.chaletBlue)),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Palette.backgroundWhite),
          textAlign: TextAlign.center,
        ));
  }
}

class CustomElevatedButtonMinor extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final Color? backgroundColor;
  const CustomElevatedButtonMinor({
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
          elevation: MaterialStateProperty.all(0.0),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(
            width: 2.0,
            color: Palette.goldLeaf,
          )),
          splashFactory: InkSplash.splashFactory,
          backgroundColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          foregroundColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Palette.goldLeaf),
        ));
  }
}

import 'package:Challet/styles/palette.dart';
import 'package:flutter/material.dart';

class CustomTextButtonRounded extends StatelessWidget {
  final Function? onPressed;
  final String label;
  const CustomTextButtonRounded({
    Key? key,
    this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed == null ? null : () => onPressed!(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Palette.backgroundWhite),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}

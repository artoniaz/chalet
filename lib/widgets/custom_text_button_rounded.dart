import 'package:chalet/styles/palette.dart';
import 'package:flutter/material.dart';

class CustomTextButtonRounded extends StatelessWidget {
  final Function onPressed;
  final String label;
  const CustomTextButtonRounded({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Palette.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))),
      ),
      child: Text(label),
    );
  }
}

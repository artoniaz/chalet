import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color color;
  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.color = Palette.backgroundWhite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPressed(),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color, decoration: TextDecoration.underline),
        ));
  }
}

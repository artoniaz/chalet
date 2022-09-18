import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;
  const TextDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: Divider()),
      HorizontalSizedBox8(),
      Text(text),
      HorizontalSizedBox8(),
      Expanded(child: Divider()),
    ]);
  }
}

import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  final Text child;
  const InputContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimentions.medium),
      decoration: BoxDecoration(color: Palette.veryLightGrey, borderRadius: BorderRadius.circular(Dimentions.medium)),
      child: child,
    );
  }
}

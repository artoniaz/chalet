import 'package:flutter/material.dart';

class CustomTopRightPositionedWidget extends StatelessWidget {
  final Widget child;
  const CustomTopRightPositionedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 1.0,
        child: FractionalTranslation(
          translation: Offset(0, 0),
          child: child,
        ));
  }
}

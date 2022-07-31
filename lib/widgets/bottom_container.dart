import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  final double? height;
  const BottomContainer({
    Key? key,
    this.height = 102.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
    );
  }
}

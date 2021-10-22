import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color spinnerColor;
  final Color backgroundColor;
  const Loading({
    Key? key,
    this.spinnerColor = Palette.skyBlue,
    this.backgroundColor = Palette.goldLeaf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitChasingDots(
          color: spinnerColor,
          size: 50,
        ),
      ),
    );
  }
}

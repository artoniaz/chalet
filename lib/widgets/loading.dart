import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.skyBlue,
      child: Center(
        child: SpinKitChasingDots(
          color: Palette.goldLeaf,
          size: 50,
        ),
      ),
    );
  }
}

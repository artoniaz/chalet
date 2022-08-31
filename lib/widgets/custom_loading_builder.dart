import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomLoadingBuilder extends StatelessWidget {
  const CustomLoadingBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        color: Palette.chaletBlue,
      ),
    ));
  }
}

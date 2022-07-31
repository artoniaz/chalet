import 'package:flutter/material.dart';

class MainImage extends StatelessWidget {
  const MainImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      width: 120.0,
      height: 120.0,
      image: AssetImage('assets/snake/snake_main.png'),
    );
  }
}

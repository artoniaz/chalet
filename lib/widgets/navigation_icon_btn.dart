import 'package:flutter/material.dart';

class NavigationIconBtn extends StatelessWidget {
  final Function onPressed;
  const NavigationIconBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Icon(Icons.navigation),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10.0),
        ),
        onPressed: () => onPressed());
  }
}

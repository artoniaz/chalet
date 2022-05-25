import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimentions.big,
      ),
      child: Center(
        child: Container(
          width: 40.0,
          height: 5.0,
          decoration: BoxDecoration(
              color: Palette.lightGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimentions.big),
              )),
        ),
      ),
    );
  }
}

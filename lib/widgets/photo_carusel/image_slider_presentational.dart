import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ImageSliderPresentational extends StatelessWidget {
  final String itemUrl;

  const ImageSliderPresentational({
    Key? key,
    required this.itemUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            CustomCachedNetworkImage(
              itemUrl: itemUrl,
              width: MediaQuery.of(context).size.width - 2 * Dimentions.big,
              height: Dimentions.pictureHeight,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery.of(context).size.width - 2 * Dimentions.big,
                  height: Dimentions.pictureHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Palette.chaletBlue, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: Dimentions.medium, horizontal: Dimentions.big),
                  child: Container()),
            ),
          ],
        ));
  }
}

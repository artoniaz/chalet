import 'package:cached_network_image/cached_network_image.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final String item;
  const ImageSlider({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: item,
              placeholder: (context, url) => Loading(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Image.network(
              item,
              fit: BoxFit.cover,
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
                      colors: [Palette.skyBlue, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: Dimentions.medium, horizontal: Dimentions.big),
                  child: Container()),
            ),
          ],
        ));
  }
}

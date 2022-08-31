import 'package:cached_network_image/cached_network_image.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String itemUrl;
  final double? width;
  final double? height;
  const CustomCachedNetworkImage({
    Key? key,
    required this.itemUrl,
    this.width,
    this.height = Dimentions.pictureHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _finalWidth = width == null ? MediaQuery.of(context).size.width - 2 * Dimentions.big : width;
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: itemUrl,
      width: _finalWidth,
      height: height,
      placeholder: (context, url) => Loading(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

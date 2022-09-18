import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ImageSliderDetails extends StatelessWidget {
  final String itemUrl;
  const ImageSliderDetails({
    Key? key,
    required this.itemUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomCachedNetworkImage(
          itemUrl: itemUrl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
        ),
      ],
    );
  }
}

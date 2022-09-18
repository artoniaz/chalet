import 'package:carousel_slider/carousel_slider.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletDetailsImageCarusel extends StatefulWidget {
  final ChaletModel chalet;
  const ChaletDetailsImageCarusel({
    Key? key,
    required this.chalet,
  }) : super(key: key);

  @override
  _ChaletDetailsImageCaruselState createState() => _ChaletDetailsImageCaruselState();
}

class _ChaletDetailsImageCaruselState extends State<ChaletDetailsImageCarusel> {
  int _currentImgIndex = 0;
  CarouselController caruselController = new CarouselController();

  List<Widget> getImgIndicators() {
    List<dynamic> images = widget.chalet.images;
    return images.map((el) {
      int index = images.indexOf(el);
      return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentImgIndex == index ? Palette.goldLeaf : Palette.darkBlue,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            carouselController: caruselController,
            items: widget.chalet.images
                .map((el) => CustomCachedNetworkImage(
                      itemUrl: el.imageUrlOriginalSize,
                      width: MediaQuery.of(context).size.width,
                    ))
                .toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: MediaQuery.of(context).size.height,
              onPageChanged: (index, reason) {
                setState(() => _currentImgIndex = index);
              },
            )),
        if (getImgIndicators().length > 1)
          Positioned(
            bottom: 4.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getImgIndicators(),
            ),
          ),
      ],
    );
  }
}

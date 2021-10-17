import 'package:carousel_slider/carousel_slider.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImageCarusel extends StatelessWidget {
  final List<ImageModelUrl> chaletModelUrlList;
  final int initialPage;
  const FullScreenImageCarusel({
    Key? key,
    required this.chaletModelUrlList,
    this.initialPage = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    double _padding = Dimentions.big;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: _screenWidth,
            height: _screenHeight,
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: CarouselSlider(
                  items: chaletModelUrlList
                      .map((el) => CustomCachedNetworkImage(
                            itemUrl: el.imageUrlOriginalSize,
                            width: _screenWidth - _padding,
                            height: _screenHeight - _padding,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height,
                    initialPage: initialPage,
                  )),
            ),
          ),
          Positioned(
              top: 24.0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  size: 50.0,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:chalet/widgets/custom_cached_network_image.dart';
import 'package:chalet/widgets/index.dart';
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
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: _screenWidth,
            height: _screenHeight,
            child: Padding(
              padding: EdgeInsets.zero,
              child: CarouselSlider(
                  items: chaletModelUrlList
                      .map((el) => Hero(
                            tag: el.imageUrlOriginalSize,
                            child: CustomCachedNetworkImage(
                              itemUrl: el.imageUrlOriginalSize,
                              width: _screenWidth - _padding,
                              height: _screenHeight - _padding,
                            ),
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
            top: 0,
            child: SafeArea(
              child: SizedBox(
                width: 72.0,
                child: CustomBackLeadingButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

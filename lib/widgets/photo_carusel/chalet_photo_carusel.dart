import 'package:chalet/models/index.dart';
import 'package:chalet/services/cloud_storage_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/photo_carusel/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChaletPhotoCarusel extends StatefulWidget {
  final ChaletModel chalet;
  const ChaletPhotoCarusel({Key? key, required this.chalet}) : super(key: key);

  @override
  _ChaletPhotoCaruselState createState() => _ChaletPhotoCaruselState();
}

class _ChaletPhotoCaruselState extends State<ChaletPhotoCarusel> {
  int _currentImgIndex = 0;
  List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    final List<ImageSlider> imageSliders = imgList
        .asMap()
        .map((i, item) => MapEntry(
            i,
            ImageSlider(
              item: item,
            )))
        .values
        .toList();
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimentions.big),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: Dimentions.pictureHeight,
                onPageChanged: (index, reason) {
                  setState(() => _currentImgIndex = index);
                },
              )),
          Positioned(
            bottom: 4.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImgIndex == index
                        ? Palette.goldLeaf
                        : Palette.darkBlue,
                  ),
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}

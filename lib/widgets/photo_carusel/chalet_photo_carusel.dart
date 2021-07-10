import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:chalet/widgets/photo_carusel/image_slider_presentational.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChaletPhotoCarusel extends StatefulWidget {
  final ChaletModel? chalet;
  final List<ImageModelFile>? chaletImagesList;
  final String chaletImageSliderPhase;
  const ChaletPhotoCarusel({
    Key? key,
    this.chalet,
    this.chaletImagesList,
    required this.chaletImageSliderPhase,
  }) : super(key: key);

  @override
  _ChaletPhotoCaruselState createState() => _ChaletPhotoCaruselState();
}

class _ChaletPhotoCaruselState extends State<ChaletPhotoCarusel> {
  int _currentImgIndex = 0;
  CarouselController caruselController = new CarouselController();

  List<Widget> getImgSliders() => widget.chaletImageSliderPhase == ChaletImageSliderPhases.ChaletList
      ? imagesToMapPresentational(widget.chalet!.images)
      : imagesToMapEditFile(widget.chaletImagesList);

  List<ImageSliderPresentational> imagesToMapPresentational(List images) => images
      .asMap()
      .map((i, item) => MapEntry(
            i,
            ImageSliderPresentational(
              itemUrl: item.imageUrlMinSize,
            ),
          ))
      .values
      .toList();

  List<ImageSliderEditFile> imagesToMapEditFile(List<ImageModelFile>? chaletImagesList) => chaletImagesList!
      .asMap()
      .map((i, item) => MapEntry(
            i,
            ImageSliderEditFile(
              itemFile: item,
              currentImgIndex: _currentImgIndex,
              imageIndex: i,
            ),
          ))
      .values
      .toList();

  List<Widget> getImgIndicators() {
    List<dynamic> images = widget.chaletImageSliderPhase == ChaletImageSliderPhases.ChaletList
        ? widget.chalet!.images
        : widget.chaletImagesList ?? [];
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
    bool isImageFromUrl = widget.chaletImageSliderPhase == ChaletImageSliderPhases.ChaletList;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(isImageFromUrl ? 5.0 : 0.0)),
      child: Container(
        margin: EdgeInsets.only(bottom: isImageFromUrl ? Dimentions.big : 0.0),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          CarouselSlider(
              carouselController: caruselController,
              items: getImgSliders(),
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: Dimentions.pictureHeight,
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
        ]),
      ),
    );
  }
}

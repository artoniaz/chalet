import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChaletPreviewContainer extends StatelessWidget {
  final ChaletModel chalet;

  const ChaletPreviewContainer({Key? key, required this.chalet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.bottomLeft,
      children: [
        ChaletPhotoCarusel(
          chalet: chalet,
          chaletImageSliderPhase: ChaletImageSliderPhases.ChaletList,
        ),
        Positioned(
          width: MediaQuery.of(context).size.width - 2 * Dimentions.big,
          bottom: Dimentions.large,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimentions.big),
            child: Text(
              chalet.name,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Palette.backgroundWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
        Positioned(
            right: Dimentions.medium,
            bottom: Dimentions.large,
            child: RatingIconLabel(
              ratingLabel: chalet.rating,
            ))
      ],
    );
  }
}

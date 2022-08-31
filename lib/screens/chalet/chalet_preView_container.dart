import 'package:Challet/config/chalet_image_slider_phases.dart';
import 'package:Challet/models/index.dart';
import 'package:Challet/screens/chalet/chalet_conveniences_types.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletPreviewContainer extends StatelessWidget {
  final ChaletModel chalet;
  final double distanceToChalet;

  const ChaletPreviewContainer({
    Key? key,
    required this.chalet,
    required this.distanceToChalet,
  }) : super(key: key);

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${distanceToChalet.toStringAsFixed(0)} m',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Palette.backgroundWhite),
                ),
                if (chalet.is24)
                  Row(
                    children: [
                      HorizontalSizedBox16(),
                      PlatformSvgAsset(
                        assetName: ConveniencesTypes.is24Green.type,
                        height: 25.0,
                        color: Palette.white,
                      ),
                    ],
                  ),
                HorizontalSizedBox16(),
                RatingIconLabel(
                  ratingLabel: chalet.rating,
                ),
              ],
            ))
      ],
    );
  }
}

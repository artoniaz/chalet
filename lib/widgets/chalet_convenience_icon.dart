import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';

class ChaletConvenienceIcon extends StatelessWidget {
  final ConvenienceType convenienceType;
  final double? convenienceScore;
  final double? size;
  final bool isMainDisplay;
  final double? width;
  final Color? iconColor;
  const ChaletConvenienceIcon({
    Key? key,
    required this.convenienceType,
    this.convenienceScore,
    this.size = 56.0,
    this.isMainDisplay = true,
    this.width,
    this.iconColor = Palette.chaletBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(Dimentions.small),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(
          isMainDisplay ? Dimentions.big : Dimentions.small,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PlatformSvgAsset(
            assetName: convenienceType.type,
            height: 50.0,
          ),
          if (isMainDisplay) VerticalSizedBox8(),
          if (isMainDisplay)
            Text(convenienceType.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
          if (convenienceScore != null) Text(convenienceScore.toString(), style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }
}

import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletConvenience extends StatelessWidget {
  final ConvenienceType convenienceType;
  final double convenienceScore;
  final double? size;
  final bool isMainDisplay;
  final double? width;
  const ChaletConvenience({
    Key? key,
    required this.convenienceType,
    required this.convenienceScore,
    this.size = 56.0,
    this.isMainDisplay = true,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: Dimentions.small),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(
          isMainDisplay ? Dimentions.big : Dimentions.small,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PlatformSvgAsset(
            assetName: convenienceType.type,
            height: 40.0,
          ),
          if (isMainDisplay) VerticalSizedBox8(),
          if (isMainDisplay) Text(convenienceType.name, style: Theme.of(context).textTheme.bodyText2),
          Text(
              convenienceType.type != ConveniencesTypes.is24Green.type &&
                      convenienceType.type != ConveniencesTypes.is24Red.type
                  ? convenienceScore.toString()
                  : '',
              style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }
}

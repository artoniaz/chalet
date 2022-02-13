import 'package:chalet/models/stat_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class StatContainer extends StatelessWidget {
  final StatModel statModel;
  const StatContainer({
    Key? key,
    required this.statModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pathFolder = 'achievementsIcons';

    return Container(
      width: (MediaQuery.of(context).size.width - Dimentions.medium * 3) / 2,
      padding: EdgeInsets.all(Dimentions.small),
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.chaletBlue,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(Dimentions.medium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PlatformSvgAsset(
              assetName: statModel.iconId.name,
              folder: pathFolder,
              width: 30.0,
              height: 30.0,
            ),
          ),
          HorizontalSizedBox8(),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statModel.title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  VerticalSizedBox8(),
                  Text(
                    statModel.subtitle,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Palette.grey,
                        ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

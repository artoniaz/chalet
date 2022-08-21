import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class AchievementContainer extends StatelessWidget {
  final bool isCompleted;
  final achievementsIds iconId;
  final String title;
  final String subtitle;
  final int? currentAchievementIndicator;
  final int? maxAchievementIndicator;
  const AchievementContainer({
    Key? key,
    required this.isCompleted,
    required this.iconId,
    required this.title,
    required this.subtitle,
    this.currentAchievementIndicator,
    this.maxAchievementIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pathFolder = 'achievementsIcons';
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimentions.small),
      decoration: BoxDecoration(
        color: isCompleted ? Palette.goldLeaf.withOpacity(0.5) : null,
        border: Border(
          bottom: BorderSide(
            color: Palette.chaletBlue,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PlatformSvgAsset(
              assetName: iconId.name,
              folder: pathFolder,
              color: isCompleted ? Palette.goldLeaf : null,
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  VerticalSizedBox8(),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Palette.grey,
                        ),
                  ),
                  if (!isCompleted)
                    Column(
                      children: [
                        VerticalSizedBox8(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimentions.medium),
                                ),
                                child: LinearProgressIndicator(
                                  backgroundColor: Palette.lightGrey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.yellowAccent,
                                  ),
                                  value: (currentAchievementIndicator! / maxAchievementIndicator!),
                                  minHeight: 20.0,
                                ),
                              ),
                            ),
                            HorizontalSizedBox8(),
                            Expanded(
                              child: Text(
                                currentAchievementIndicator.toString() + ' / ' + maxAchievementIndicator.toString(),
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ))
        ],
      ),
    );
  }
}

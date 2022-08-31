import 'package:Challet/config/helpers/achievements_ids.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class AchievementContainer extends StatelessWidget {
  final bool isCompleted;
  final achievementsIds iconId;
  final String title;
  final String subtitle;
  final int? currentAchievementIndicator;
  final int? maxAchievementIndicator;
  final bool isLast;
  const AchievementContainer({
    Key? key,
    required this.isCompleted,
    required this.iconId,
    required this.title,
    required this.subtitle,
    this.currentAchievementIndicator,
    this.maxAchievementIndicator,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pathFolder = 'achievementsIcons';
    return Container(
      height: 100.0,
      padding: EdgeInsets.symmetric(vertical: Dimentions.small),
      decoration: BoxDecoration(
        color: isCompleted ? Palette.goldLeaf.withOpacity(0.4) : null,
        border: Border(
          bottom: BorderSide(
            color: Palette.chaletBlue,
            width: isLast ? 0.0 : 2.0,
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
              color: iconId == achievementsIds.traveller ? Palette.confirmGreen : null,
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  if (isCompleted)
                    Column(
                      children: [
                        VerticalSizedBox8(),
                        Text(
                          'Zdobyto',
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                                color: Palette.confirmGreen,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
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

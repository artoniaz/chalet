import 'package:chalet/config/functions/team_stats_calc.dart';
import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/models/stat_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int chaletAddedNumber;
  final int chaletReviewsNumber;
  const StatsGrid({
    Key? key,
    required this.chaletAddedNumber,
    required this.chaletReviewsNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimentions.medium,
      ),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: Dimentions.small,
        crossAxisSpacing: Dimentions.medium,
        childAspectRatio: 2.2,
        children: [
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.traveller,
              title: chaletAddedNumber.toString(),
              subtitle: 'Dodane szalety',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: '0',
              subtitle: 'Posiedzień dziennie',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: chaletReviewsNumber.toString(),
              subtitle: 'Posiedzień',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: '0',
              subtitle: 'Posiedzeń tygodniowo',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.timeSpent,
              title: timeInChalet(chaletReviewsNumber).toString() + ' min',
              subtitle: 'Czas spędzony w szaletach',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: '0',
              subtitle: 'Posiedzeń miesięcznie',
            ),
          ),
        ],
      ),
    );
  }
}

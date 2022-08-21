import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/models/stat_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int chaletAddedNumber;
  final int chaletReviewsNumber;
  final Timestamp userCreatedTimestamp;
  const StatsGrid({
    Key? key,
    required this.chaletAddedNumber,
    required this.chaletReviewsNumber,
    required this.userCreatedTimestamp,
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
              title: (chaletReviewsNumber / TimestampHelpers.daysNumberSinceTimestamp(userCreatedTimestamp))
                  .toStringAsFixed(2),
              subtitle: 'Posiedzeń dziennie',
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
              title: (chaletReviewsNumber / TimestampHelpers.monthsNumberSinceTimestamp(userCreatedTimestamp))
                  .toStringAsFixed(2),
              subtitle: 'Posiedzień miesięcznie',
            ),
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: (chaletReviewsNumber ~/ TimestampHelpers.yearNumberSinceTimestamp(userCreatedTimestamp))
                  .toInt()
                  .toString(),
              subtitle: 'Posiedzeń rocznie',
            ),
          ),
        ],
      ),
    );
  }
}

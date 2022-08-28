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
  final Timestamp createdTimestamp;
  const StatsGrid({
    Key? key,
    required this.chaletAddedNumber,
    required this.chaletReviewsNumber,
    required this.createdTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    double containerWidth = (MediaQuery.of(context).size.width - Dimentions.medium * 3) / 2;

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
            containerWidth: containerWidth,
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: (chaletReviewsNumber / TimestampHelpers.daysNumberSinceTimestamp(createdTimestamp))
                  .toStringAsFixed(2),
              subtitle: 'Posiedzeń dziennie',
            ),
            containerWidth: containerWidth,
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: chaletReviewsNumber.toString(),
              subtitle: 'Posiedzień',
            ),
            containerWidth: containerWidth,
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: (chaletReviewsNumber / TimestampHelpers.monthsNumberSinceTimestamp(createdTimestamp))
                  .toStringAsFixed(1)
                  .replaceAll(regex, ''),
              subtitle: 'Posiedzień miesięcznie',
            ),
            containerWidth: containerWidth,
          ),
          Container(
            width: containerWidth,
          ),
          StatContainer(
            statModel: StatModel(
              iconId: achievementsIds.sittingKing,
              title: (chaletReviewsNumber ~/ TimestampHelpers.yearNumberSinceTimestamp(createdTimestamp))
                  .toStringAsFixed(1)
                  .replaceAll(regex, ''),
              subtitle: 'Posiedzeń rocznie',
            ),
            containerWidth: containerWidth,
          ),
        ],
      ),
    );
  }
}

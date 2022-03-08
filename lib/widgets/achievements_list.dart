import 'package:chalet/config/functions/team_stats_calc.dart';
import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/palette.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class AchievementsList extends StatelessWidget {
  final UserModel user;
  const AchievementsList({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(
            color: Palette.chaletBlue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(Dimentions.medium),
        ),
        child: Column(
          children: [
            AchievementContainer(
              isCompleted: user.achievementsIds.contains(achievementsIds.sittingKing.name),
              iconId: achievementsIds.sittingKing,
              title: 'Siedzący król',
              subtitle: 'Dodaj 5 ocen Szaletu',
              currentAchievementIndicator: user.chaletReviewsNumber,
              maxAchievementIndicator: 5,
            ),
            AchievementContainer(
              isCompleted: user.achievementsIds.contains(achievementsIds.traveller.name),
              iconId: achievementsIds.traveller,
              title: 'Obieżyświat',
              subtitle: 'Dodaj 10 Szaletów na mapę',
              currentAchievementIndicator: user.chaletsAddedNumber,
              maxAchievementIndicator: 10,
            ),
            AchievementContainer(
              isCompleted: user.achievementsIds.contains(achievementsIds.writter.name),
              iconId: achievementsIds.writter,
              title: 'Kronikarz',
              //TODO: ustalić jak to ma być liczone
              subtitle: 'Dodawaj oceny przez 15 dni, chwilowo nie działa',
              currentAchievementIndicator: 2,
              maxAchievementIndicator: 5,
            ),
            AchievementContainer(
              isCompleted: user.achievementsIds.contains(achievementsIds.timeSpent.name),
              iconId: achievementsIds.timeSpent,
              title: 'Pustelnik',
              subtitle: 'Spędź łacznie 60 minut w Szalecie',
              currentAchievementIndicator: timeInChalet(user.chaletReviewsNumber),
              maxAchievementIndicator: 60,
            ),
          ],
        ),
      ),
    );
  }
}

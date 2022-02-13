import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
import 'package:chalet/config/functions/team_stats_calc.dart';
import 'package:chalet/config/helpers/achievements_ids.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/palette.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AchievementsList extends StatelessWidget {
  const AchievementsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
        bloc: Provider.of<UserDataBloc>(context, listen: false),
        builder: (context, userState) {
          if (userState is UserDataStateLoaded)
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
                      isCompleted: userState.user.achievementsIds != null &&
                          userState.user.achievementsIds!.contains(achievementsIds.sittingKing.name),
                      iconId: achievementsIds.sittingKing,
                      title: 'Siedzący król',
                      subtitle: 'Dodaj 5 ocen Szaletu',
                      currentAchievementIndicator: userState.user.chaletReviewsNumber,
                      maxAchievementIndicator: 5,
                    ),
                    AchievementContainer(
                      isCompleted: userState.user.achievementsIds != null &&
                          userState.user.achievementsIds!.contains(achievementsIds.traveller.name),
                      iconId: achievementsIds.traveller,
                      title: 'Obieżyświat',
                      subtitle: 'Dodaj 10 Szaletów na mapę',
                      currentAchievementIndicator: userState.user.chaletsAddedNumber,
                      maxAchievementIndicator: 10,
                    ),
                    AchievementContainer(
                      isCompleted: userState.user.achievementsIds != null &&
                          userState.user.achievementsIds!.contains(achievementsIds.writter.name),
                      iconId: achievementsIds.writter,
                      title: 'Kronikarz',
                      //TODO: ustalić jak to ma być liczone
                      subtitle: 'Dodawaj oceny przez 15 dni, chwilowo nie działa',
                      currentAchievementIndicator: 2,
                      maxAchievementIndicator: 5,
                    ),
                    AchievementContainer(
                      isCompleted: userState.user.achievementsIds != null &&
                          userState.user.achievementsIds!.contains(achievementsIds.timeSpent.name),
                      iconId: achievementsIds.timeSpent,
                      title: 'Pustelnik',
                      subtitle: 'Spędź łacznie 60 minut w Szalecie',
                      currentAchievementIndicator: timeInChalet(userState.user.chaletReviewsNumber),
                      maxAchievementIndicator: 60,
                    ),
                  ],
                ),
              ),
            );
          else
            return Loading();
        });
  }
}

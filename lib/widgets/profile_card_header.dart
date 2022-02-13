import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfileCardHeader extends StatelessWidget {
  final UserModel user;
  const ProfileCardHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimentions.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? '',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                VerticalSizedBox8(),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Palette.grey,
                      ),
                ),
                VerticalSizedBox8(),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Palette.chaletBlue,
                    ),
                    HorizontalSizedBox8(),
                    BlocBuilder<TeamBloc, TeamState>(
                        bloc: Provider.of<TeamBloc>(context, listen: false),
                        builder: (context, teamState) {
                          if (teamState is TeamStateTeamLoaded) {
                            return Text(
                              teamState.team.name,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Palette.chaletBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                            );
                          } else
                            return CircularProgressIndicator();
                        }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: CircleAvatar(
            radius: 40,
          )),
        ],
      ),
    );
  }
}

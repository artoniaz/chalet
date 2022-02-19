import 'package:chalet/blocs/delete_team_member/delete_team_member_bloc.dart';
import 'package:chalet/blocs/delete_team_member/delete_team_member_event.dart';
import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/config/functions/check_is_user_admin.dart';
import 'package:chalet/models/team_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamMemberContainer extends StatelessWidget {
  final UserModel teamMember;
  final double circleAvatarRadius;
  const TeamMemberContainer({
    Key? key,
    required this.teamMember,
    required this.circleAvatarRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserDataBloc>(context, listen: false).user;
    TeamModel _team = Provider.of<TeamBloc>(context, listen: false).team;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (circleAvatarRadius + 20.0) * 2,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 6.0),
            child: Column(children: [
              CircleAvatar(
                radius: circleAvatarRadius + 5.0,
                backgroundColor: teamMember.uid == _team.teamAdminId ? Palette.goldLeaf : Palette.chaletBlue,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/poo/poo_happy.png',
                  ),
                  radius: circleAvatarRadius,
                ),
              ),
              VerticalSizedBox8(),
              Text(
                teamMember.displayName ?? '',
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
          if (isUserTeamAdmin(_team.teamAdminId, _user.uid) && teamMember.uid != _user.uid)
            Positioned(
                top: 0,
                right: 1.0,
                child: FractionalTranslation(
                  translation: Offset(0, 0),
                  child: CustomRoundedIconButton(
                      iconData: Icons.delete,
                      iconSize: 20.0,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                              headline: 'Czy chcesz usunąć tego użytownika z klanu?',
                              approveFunction: () =>
                                  Provider.of<DeleteTeamMemberBloc>(context, listen: false).add(DeleteTeamMember(
                                    _team,
                                    teamMember.uid,
                                    _user,
                                    teamMember.choosenColor!,
                                  )),
                              approveFunctionButtonLabel: 'Usuń z klanu'))),
                )),
        ],
      ),
    );
  }
}

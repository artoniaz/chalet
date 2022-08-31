import 'package:Challet/blocs/delete_team_member/delete_team_member_bloc.dart';
import 'package:Challet/blocs/delete_team_member/delete_team_member_event.dart';
import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/config/functions/check_is_user_admin.dart';
import 'package:Challet/models/team_model.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
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
              UserAvatar(
                avatarId: teamMember.avatarId!,
                radius: circleAvatarRadius,
                backgroundColor: teamMember.uid == _team.teamAdminId ? Palette.goldLeaf : Palette.chaletBlue,
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
            CustomTopRightPositionedWidget(
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
            ),
        ],
      ),
    );
  }
}

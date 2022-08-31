import 'package:Challet/blocs/team_member/team_member_bloc.dart';
import 'package:Challet/blocs/team_member/team_member_event.dart';
import 'package:Challet/screens/social/create_team/add_member_to_team.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMemberIcon extends StatelessWidget {
  final double circleAvatarRadius;
  final double borderWidth;
  const AddMemberIcon({
    Key? key,
    required this.circleAvatarRadius,
    required this.borderWidth,
  }) : super(key: key);

  _onComplete(BuildContext context) => Provider.of<TeamMemberBloc>(context, listen: false).add(ResetTeamMemberBloc());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: circleAvatarRadius + borderWidth,
          backgroundColor: Palette.chaletBlue,
          child: IconButton(
            onPressed: () => showCustomModalBottomSheet(
              context,
              (context) => AddMemberToTeam(),
              _onComplete(context),
            ),
            iconSize: circleAvatarRadius + 15.0,
            icon: Icon(
              Icons.add,
              color: Palette.white,
            ),
          ),
        ),
        VerticalSizedBox8(),
        Text(''),
      ],
    );
  }
}

import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class TeamMemberContainer extends StatelessWidget {
  final TeamMemberModel teamMember;
  final double circleAvatarRadius;
  const TeamMemberContainer({
    Key? key,
    required this.teamMember,
    required this.circleAvatarRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      child: Column(children: [
        CircleAvatar(
          radius: circleAvatarRadius + 5.0,
          backgroundColor: teamMember.isAdmin ? Palette.goldLeaf : Palette.chaletBlue,
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/poo/poo_happy.png',
            ),
            radius: circleAvatarRadius,
          ),
        ),
        VerticalSizedBox8(),
        Text(
          teamMember.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ]),
    );
  }
}

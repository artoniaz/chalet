import 'package:Challet/config/index.dart';
import 'package:Challet/models/screen_arg.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';

class TeamStatsMemberContainer extends StatelessWidget {
  final UserModel teamMember;
  const TeamStatsMemberContainer({
    Key? key,
    required this.teamMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimentions.small),
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.chaletBlue,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(Dimentions.medium),
      ),
      child: ListTile(
        leading: CircleAvatar(),
        contentPadding: EdgeInsets.symmetric(horizontal: Dimentions.small),
        title: Text(teamMember.displayName ?? ''),
        isThreeLine: true,
        minVerticalPadding: 0,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSizedBox8(),
            Text(teamMember.chaletReviewsNumber.toString() + ' posiedzeń'),
            VerticalSizedBox8(),
            Text(teamMember.chaletsAddedNumber.toString() + ' Dodanych szaletów'),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 50,
        ),
        onTap: () => Navigator.pushNamed(context, RoutesDefinitions.OTHER_USER_PROFILE,
            arguments: UserModelArg(userModel: teamMember)),
      ),
    );
  }
}

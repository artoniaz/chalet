import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String avatarId;
  final double radius;
  final Color? backgroundColor;
  const UserAvatar({
    Key? key,
    required this.avatarId,
    required this.radius,
    this.backgroundColor = Palette.chaletBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + 2,
      backgroundColor: backgroundColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Palette.white,
        backgroundImage: AssetImage('assets/avatarIcons/$avatarId.jpeg'),
      ),
    );
  }
}

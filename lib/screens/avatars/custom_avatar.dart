import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String avatarId;
  final String currentAvatarId;
  final Function(String) onTapAvatar;
  const CustomAvatar({
    Key? key,
    required this.avatarId,
    required this.currentAvatarId,
    required this.onTapAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double radius = 35.0;
    return GestureDetector(
      onTap: () => onTapAvatar(avatarId),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          UserAvatar(
            avatarId: avatarId,
            radius: radius,
            backgroundColor: currentAvatarId == avatarId ? Palette.goldLeaf : Palette.chaletBlue,
          ),
          if (currentAvatarId == avatarId)
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Palette.goldLeaf,
                  child: Icon(
                    Icons.check,
                    color: Palette.white,
                  )),
            ),
        ],
      ),
    );
  }
}

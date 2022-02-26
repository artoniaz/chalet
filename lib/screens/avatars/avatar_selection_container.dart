import 'package:chalet/screens/avatars/custom_avatar.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/widgets/horizontal_sized_boxes.dart';
import 'package:flutter/material.dart';

class AvatarSelectionContainer extends StatelessWidget {
  final Function(String) onTapAvatar;
  final String currentAvatarId;
  const AvatarSelectionContainer({
    Key? key,
    required this.onTapAvatar,
    required this.currentAvatarId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomAvatar(
            avatarId: 'sittingKing',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'timeSpent',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'traveller',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'writter',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
        ],
      ),
    );
  }
}

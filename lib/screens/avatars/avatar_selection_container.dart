import 'package:Challet/screens/avatars/custom_avatar.dart';
import 'package:Challet/widgets/horizontal_sized_boxes.dart';
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
            avatarId: 'avatar_icon_1',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'avatar_icon_2',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'avatar_icon_3',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'avatar_icon_4',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'avatar_icon_5',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
          HorizontalSizedBox4(),
          CustomAvatar(
            avatarId: 'avatar_icon_6',
            currentAvatarId: currentAvatarId,
            onTapAvatar: onTapAvatar,
          ),
        ],
      ),
    );
  }
}

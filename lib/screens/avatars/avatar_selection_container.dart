import 'package:chalet/screens/avatars/custom_avatar.dart';
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
    const _avatarCounter = 14;
    return Container(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CustomAvatar(
          avatarId: 'avatar_icon_${index + 1}',
          currentAvatarId: currentAvatarId,
          onTapAvatar: onTapAvatar,
        ),
        separatorBuilder: (_, i) => HorizontalSizedBox4(),
        itemCount: _avatarCounter,
      ),
    );
  }
}

import 'dart:io';

import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/storage_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomAvatar extends StatelessWidget {
  final String? photoURL;
  const CustomAvatar({
    Key? key,
    required this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return photoURL == null
        ? Container(
            width: 200,
            height: 200,
            child: CircleAvatar(
              backgroundColor: Palette.chaletBlue,
            ))
        : ClipOval(
            child: photoURL == null
                ? Container()
                : CustomCachedNetworkImage(
                    itemUrl: photoURL ?? '',
                    width: 200,
                    height: 200,
                  ));
  }
}

class CustomCircleAvatar extends StatelessWidget {
  final String? photoURL;
  const CustomCircleAvatar({
    Key? key,
    required this.photoURL,
  }) : super(key: key);

  void _getImageFromGallery(BuildContext context) async {
    String userUid = (context.read<UserDataBloc>().state.props.first as UserModel).uid;

    final _picker = ImagePicker();
    XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 600, maxWidth: 600);
    var imageFile = File(pickedImage?.path ?? '');
    StorageService().editUserPhotoURL(userUid, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.fromLTRB(Dimentions.small, Dimentions.small, Dimentions.small, Dimentions.small),
      // child: Stack(
      //   alignment: Alignment.center,
      //   clipBehavior: Clip.antiAliasWithSaveLayer,
      //   children: [
      //     CustomAvatar(
      //       photoURL: photoURL,
      //     ),
      //     Positioned(
      //       top: 5,
      //       left: width / 2 + 50,
      //       child: FractionalTranslation(
      //         translation: Offset(0, 0),
      //         child: CustomRoundedIconButton(
      //             onPressed: () => _getImageFromGallery(context), iconData: Icons.edit, iconSize: 25.0),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

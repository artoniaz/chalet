import 'dart:io';

import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/storage_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String photoURL;
  const CustomCircleAvatar({
    Key? key,
    required this.photoURL,
  }) : super(key: key);

  void _getImageFromGallery(BuildContext context) async {
    String userUid = Provider.of<UserModel?>(context, listen: false)!.uid;
    final _picker = ImagePicker();
    PickedFile? pickedImage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 300, maxWidth: 300);
    var imageFile = File(pickedImage?.path ?? '');
    StorageService().editUserPhotoURL(userUid, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimentions.small),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            child: CircleAvatar(
              backgroundImage: NetworkImage(photoURL),
              backgroundColor: Palette.chaletBlue,
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimentions.small),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _getImageFromGallery(context),
            ),
          ),
        ],
      ),
    );
  }
}

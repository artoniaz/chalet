import 'package:flutter/material.dart';

void imageSourceBottomSheet(
  BuildContext context, {
  required Function handleGalleryImg,
  required Function handleCameraImg,
}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeria'),
                onTap: () {
                  handleGalleryImg();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Aparat'),
                onTap: () {
                  handleCameraImg();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
      });
}

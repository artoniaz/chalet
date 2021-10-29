import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChaletImagePicker extends StatelessWidget {
  const ChaletImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileListModel>(builder: (context, imageFileList, child) {
      return Container(
        height: Dimentions.pictureHeight,
        width: MediaQuery.of(context).size.width,
        color: Palette.backgroundWhite,
        //TODO: finish
        child: imageFileList.images.isEmpty
            ? Center(
                child: CustomElevatedButton(
                  label: 'zrób zdjęcie',
                  //TODO: implement functions
                  onPressed: () => imageSourceBottomSheet(
                    context,
                    handleGalleryImg: () {},
                    handleCameraImg: imageFileList.getImageCamera(),
                  ),
                  backgroundColor: Palette.darkBlue,
                ),
              )
            : ChaletPhotoCarusel(
                chaletImagesList: imageFileList.images,
                chaletImageSliderPhase: ChaletImageSliderPhases.AddChalet,
              ),
      );
    });
  }
}

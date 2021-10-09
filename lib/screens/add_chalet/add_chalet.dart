import 'dart:io';

import 'package:chalet/config/index.dart';
import 'package:chalet/models/add_chalet_nav_pass_args.dart';
import 'package:chalet/models/custom_geo_point.dart';
import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/services/storage_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddChalet extends StatefulWidget {
  const AddChalet({Key? key}) : super(key: key);

  @override
  _AddChaletState createState() => _AddChaletState();
}

class _AddChaletState extends State<AddChalet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChaletModel _chalet = new ChaletModel(
    // id: '',
    name: '',
    rating: 0.0,
    quality: 0.0,
    clean: 0.0,
    paper: 0.0,
    privacy: 0.0,
    description: '',
    images: [],
    position: GeoFirePoint(0, 0),
  );

  String? _chaletLocalizationAddress;
  bool isFormAllowed = true;
  bool isCreatBtnActive = true;

  void handleQualityRatingUpdate(double rating) => setState(() => _chalet.quality = rating);
  void handleCleanRatingUpdate(double rating) => setState(() => _chalet.clean = rating);
  void handlePaperRatingUpdate(double rating) => setState(() => _chalet.paper = rating);
  void handlePrivacyRatingUpdate(double rating) => setState(() => _chalet.privacy = rating);

  double calcRating(ChaletModel chaletModel) {
    List ratings = [chaletModel.quality, chaletModel.clean, chaletModel.paper, chaletModel.privacy];
    return ratings.reduce((value, element) => value + element) / ratings.length;
  }

  void _navigateToLocalizationAndGetChaletLocalization(BuildContext context) async {
    AddChaletNavigationPassingArgs? chaletLocalizationArgs =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddChaletMap()));
    if (chaletLocalizationArgs != null) {
      setState(() {
        _chaletLocalizationAddress = chaletLocalizationArgs.chaletAddress.street;
        _chalet.position = Geoflutterfire().point(
          latitude: chaletLocalizationArgs.chaletLocalization.latitude,
          longitude: chaletLocalizationArgs.chaletLocalization.longitude,
        );
      });
    }
  }

  Future<void> createChalet() async {
    setState(() => isCreatBtnActive = false);

    if (_formKey.currentState!.validate()) {
      if (_chalet.quality > 0 && _chalet.clean > 0 && _chalet.paper > 0 && _chalet.privacy > 0) {
        EasyLoading.show(status: '', maskType: EasyLoadingMaskType.black);
        try {
          ImageFileListModel imageListModel = Provider.of<ImageFileListModel>(context, listen: false);

          _chalet.rating = calcRating(_chalet);
          String? chaletId = await ChaletService().createChalet(_chalet);
          await StorageService().addImagesToStorage(chaletId ?? '', imageListModel.images);
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Szalet dodano');
          //TODO: go to details to display added chalet
        } catch (e) {
          print(e);
          EasyLoading.dismiss();
          EasyLoading.showError('Wystąpił błąd. Dodaj szalet ponownie');
        }
      } else
        setState(() => isFormAllowed = false);
    }
    setState(() => isCreatBtnActive = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => dissmissCurrentFocus(context),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ChaletImagePicker(),
                Padding(
                  padding: const EdgeInsets.all(Dimentions.big),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Nazwa'),
                        validator: (val) => val!.isEmpty ? 'To pole jest obowiązkowe' : null,
                        onChanged: (val) => setState(() => _chalet.name = val),
                      ),
                      VerticalSizedBox16(),
                      Text('Uzupełnij wszystkie oceny.',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: isFormAllowed ? Palette.white : Palette.errorRed)),
                      VerticalSizedBox8(),
                      RatingBarRow(
                        label: 'Jakość',
                        handleRatingUpdate: handleQualityRatingUpdate,
                      ),
                      RatingBarRow(
                        label: 'Czystość',
                        handleRatingUpdate: handleCleanRatingUpdate,
                      ),
                      RatingBarRow(label: 'Papier', handleRatingUpdate: handlePaperRatingUpdate),
                      RatingBarRow(
                        label: 'Prywatność',
                        handleRatingUpdate: handlePrivacyRatingUpdate,
                      ),
                      VerticalSizedBox8(),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Opis'),
                        onChanged: (val) => setState(() => _chalet.description = val),
                      ),
                      VerticalSizedBox8(),
                      CustomElevatedButton(
                        label: 'Lokalizacja',
                        onPressed: () => _navigateToLocalizationAndGetChaletLocalization(context),
                      ),
                      if (_chaletLocalizationAddress != null) Text(_chaletLocalizationAddress ?? ''),
                      CustomElevatedButtonIcon(
                        onPressed: isCreatBtnActive ? createChalet : null,
                        label: 'Dodaj szalet',
                        iconData: Icons.add,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

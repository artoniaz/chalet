import 'package:chalet/blocs/add_chalet/add_chalet_bloc.dart';
import 'package:chalet/blocs/add_chalet/add_chalet_event.dart';
import 'package:chalet/blocs/add_chalet/add_chalet_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/add_chalet_nav_pass_args.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddChaletRoot extends StatelessWidget {
  const AddChaletRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageFileListModel(),
      child: AddChalet(),
    );
  }
}

class AddChalet extends StatefulWidget {
  const AddChalet({Key? key}) : super(key: key);

  @override
  _AddChaletState createState() => _AddChaletState();
}

class _AddChaletState extends State<AddChalet> {
  late AddChaletBloc _addChaletBloc;
  late UserModel? _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChaletModel _chalet = new ChaletModel(
    id: '',
    name: '',
    rating: 0.0,
    numberRating: 1,
    numberDetailedRating: 1,
    descriptionHowToGet: '',
    venueDescription: '',
    clean: 0.0,
    paper: 0.0,
    privacy: 0.0,
    description: '',
    images: [],
    position: GeoFirePoint(0, 0),
    isVerified: false,
    is24: false,
    creatorName: '',
    creatorId: '',
  );

  LatLng? _chaletLocalizationLatLag;
  bool _isLocalizationChoosen = false;
  bool isFormAllowed = true;

  void _handleGeneralRatingUpdate(double rating) {
    setState(() => _chalet.rating = rating);
    dissmissCurrentFocus(context);
  }

  void _handleCleanRatingUpdate(double rating) {
    setState(() => _chalet.clean = rating);
    dissmissCurrentFocus(context);
  }

  void _handlePaperRatingUpdate(double rating) {
    setState(() => _chalet.paper = rating);
    dissmissCurrentFocus(context);
  }

  void _handlePrivacyRatingUpdate(double rating) {
    setState(() => _chalet.privacy = rating);
    dissmissCurrentFocus(context);
  }

  void _handleis24Update(bool val) {
    setState(() => _chalet.is24 = val);
    dissmissCurrentFocus(context);
  }

  void _navigateToLocalizationAndGetChaletLocalization(BuildContext context) async {
    dissmissCurrentFocus(context);
    AddChaletNavigationPassingArgs? chaletLocalizationArgs =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddChaletMap()));
    if (chaletLocalizationArgs != null) {
      setState(() {
        _chaletLocalizationLatLag = chaletLocalizationArgs.chaletLocalization;
        _isLocalizationChoosen = true;
        _chalet.position = Geoflutterfire().point(
          latitude: chaletLocalizationArgs.chaletLocalization.latitude,
          longitude: chaletLocalizationArgs.chaletLocalization.longitude,
        );
      });
    }
  }

  Future<void> createChalet() async {
    if (_formKey.currentState!.validate()) {
      ImageFileListModel imageListModel = Provider.of<ImageFileListModel>(context, listen: false);
      if (_chalet.clean > 0 && _chalet.paper > 0 && _chalet.privacy > 0 && imageListModel.images.isNotEmpty) {
        _chalet.creatorName = _user?.displayName ?? 'anonimowy użytkownik';
        _chalet.creatorId = _user?.uid ?? '';
        _addChaletBloc.add(CreateChalet(
          _chalet,
          imageListModel.images,
          _user!.teamId == null
              ? null
              : FeedInfoModel(
                  id: '',
                  teamId: _user!.teamId ?? '',
                  userId: _user!.uid,
                  chaletId: _chalet.id,
                  chaletName: _chalet.name,
                  userName: _user!.displayName ?? '',
                  role: FeedInfoEvent.addChalet,
                  chaletRating: _chalet.numberRating.toDouble(),
                  created: Timestamp.now(),
                  congratsSenderList: [],
                  achievementId: '',
                  userAvatarId: _user!.avatarId ?? '',
                ),
        ));
      } else
        setState(() => isFormAllowed = false);
    }
  }

  @override
  void initState() {
    _addChaletBloc = BlocProvider.of<AddChaletBloc>(context, listen: false);
    _user = context.read<UserDataBloc>().state.props.first as UserModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddChaletBloc, AddChaletState>(
        bloc: _addChaletBloc,
        listener: (context, state) {
          if (state is AddChaletStateLoading) {
            EasyLoading.show();
          } else if (state is AddChaletChaletAddedLoadingImages) {
            EasyLoading.show(status: 'Teraz ładujemy Twoje zdjęcia. To może chwilę potrwać.');
          } else if (state is AddChaletStateCreated) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess('Szalet dodano');
            Navigator.pushReplacementNamed(context, RoutesDefinitions.CHALET_DETAILS,
                arguments: ChaletDetailsArgs(chalet: state.chalet, returnPage: Home()));
          } else if (state is AddChaletStateError) {
            EasyLoading.dismiss();
            EasyLoading.showError('Wystąpił błąd. Dodaj szalet ponownie');
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () => dissmissCurrentFocus(context),
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Column(
                          children: [
                            ChaletImagePicker(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  Dimentions.big, Dimentions.big, Dimentions.big, Dimentions.large),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(hintText: 'Nazwa Szaletu'),
                                    validator: (val) => val!.isEmpty ? 'To pole jest obowiązkowe' : null,
                                    onChanged: (val) => setState(() => _chalet.name = val),
                                  ),
                                  VerticalSizedBox16(),
                                  Text(
                                      isFormAllowed
                                          ? 'Uzupełnij wszystkie oceny'
                                          : 'Uzupełnij wszystkie oceny i dodaj zdjęcie',
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: isFormAllowed ? Palette.ivoryBlack : Palette.errorRed)),
                                  VerticalSizedBox8(),
                                  RatingBarRow(
                                    label: 'Ocena ogólna',
                                    handleRatingUpdate: _handleGeneralRatingUpdate,
                                  ),
                                  Divider(),
                                  SwitchBar(
                                    label: 'Otwarty całą dobę?',
                                    handleis24Update: _handleis24Update,
                                    value: _chalet.is24,
                                  ),
                                  RatingBarRow(
                                    label: 'Czystość',
                                    handleRatingUpdate: _handleCleanRatingUpdate,
                                  ),
                                  RatingBarRow(label: 'Papier', handleRatingUpdate: _handlePaperRatingUpdate),
                                  RatingBarRow(
                                    label: 'Prywatność',
                                    handleRatingUpdate: _handlePrivacyRatingUpdate,
                                  ),
                                  Divider(),
                                  VerticalSizedBox8(),
                                  Text(
                                    'Opis budynku / adres',
                                    style: Theme.of(context).textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  VerticalSizedBox8(),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        hintText:
                                            'W jakim budynku znajduje się Szalet? (Stacja benzynowa/bilioteka/uniwersytet/przejście podziemne etc.)'),
                                    minLines: 3,
                                    maxLines: 4,
                                    onChanged: (val) => setState(() => _chalet.venueDescription = val),
                                    validator: (val) => val!.isEmpty ? 'To pole jest obowiązkowe' : null,
                                  ),
                                  VerticalSizedBox16(),
                                  Text(
                                    'Jak trafić',
                                    style: Theme.of(context).textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  VerticalSizedBox8(),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        hintText:
                                            'Wskaż innym drogę do Szaletu (piętro, które drzwi, tajne przejścia etc.)'),
                                    minLines: 3,
                                    maxLines: 4,
                                    onChanged: (val) => setState(() => _chalet.descriptionHowToGet = val),
                                    validator: (val) => val!.isEmpty ? 'To pole jest obowiązkowe' : null,
                                  ),
                                  VerticalSizedBox16(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _chaletLocalizationLatLag == null
                                              ? 'Wybierz lokalizację'
                                              : 'Lokalizacja wybrana poprawnie',
                                          style: Theme.of(context).textTheme.headline6!.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalSizedBox8(),
                                  CustomElevatedButton(
                                    label: _chaletLocalizationLatLag == null ? 'Lokalizacja' : 'Zmień lokalizację',
                                    onPressed: () => _navigateToLocalizationAndGetChaletLocalization(context),
                                  ),
                                  VerticalSizedBox16(),
                                  CustomElevatedButton(
                                    onPressed: state is AddChaletStateLoading ||
                                            state is AddChaletChaletAddedLoadingImages ||
                                            !_isLocalizationChoosen
                                        ? null
                                        : createChalet,
                                    label: 'Zatwiedź dodawanie Szaletu',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 72.0,
                          child: CustomBackLeadingButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/add_chalet_nav_pass_args.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chalet/widgets/index.dart';

class AddChaletMap extends StatefulWidget {
  const AddChaletMap({Key? key}) : super(key: key);

  @override
  _AddChaletMapState createState() => _AddChaletMapState();
}

class _AddChaletMapState extends State<AddChaletMap> {
  late GoogleMapController _googleMapController;
  late LatLng _chaletLatLngPosition;
  late Placemark _chaletAddressPlacemark;
  late LatLng _initialUserPosition;
  Marker? _chaletMarker;

  bool _isCameraLoading = true;
  bool _isCameraBackToUserLocationBtnActive = false;
  static const double _cameraZoom = 18.0;
  double middleMarkerSize = 50.0;
  double _middleMarkerAnimationMove = 0.0;

  void navigateBackAndPassChaletLocalization() {
    AddChaletNavigationPassingArgs passingArgs = new AddChaletNavigationPassingArgs(
        chaletLocalization: _chaletLatLngPosition, chaletAddress: _chaletAddressPlacemark);
    Navigator.pop(context, passingArgs);
  }

  void navigateToAddressInputScreen() async {
    Location? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddressInputScreen()));
    if (result != null) {
      var positon = LatLng(result.latitude, result.longitude);
      setState(() => _chaletLatLngPosition = LatLng(result.latitude, result.longitude));
      _animateCamera(positon);
    }
  }

  void _getInitialCameraPositon() async {
    LatLng initPos = await GeolocationService().getUserLocation();
    List<Placemark> addresses = await GeolocationService().getAddressfromCoords(initPos);
    setState(() {
      _initialUserPosition = initPos;
      _chaletLatLngPosition = initPos;
      _chaletAddressPlacemark = addresses.first;
      _isCameraLoading = false;
    });
  }

  void _animateCamera(LatLng cameraPosition) {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: cameraPosition,
          zoom: _cameraZoom,
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) => _chaletLatLngPosition = position.target;

  void _onCameraIdle() async {
    List<Placemark> addresses = await GeolocationService().getAddressfromCoords(_chaletLatLngPosition);
    setState(() {
      _isCameraBackToUserLocationBtnActive = !compareLatLng(_initialUserPosition, _chaletLatLngPosition);
      if (addresses[0].street!.toLowerCase() != 'unnamed road') _chaletAddressPlacemark = addresses[0];
      _middleMarkerAnimationMove = 0.0;
    });
  }

  void _onCameraMoveStarted() {
    setState(() {
      _middleMarkerAnimationMove = 20.0;
    });
  }

  @override
  void initState() {
    _getInitialCameraPositon();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBars.customTransparentAppBar(context),
      body: _isCameraLoading
          ? Loading()
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _initialUserPosition, zoom: _cameraZoom),
                  onMapCreated: (controller) => _googleMapController = controller,
                  onCameraMoveStarted: _onCameraMoveStarted,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  markers: {
                    if (_chaletMarker != null) _chaletMarker!,
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  child: Positioned(
                      top: MediaQuery.of(context).size.height / 2 - _middleMarkerAnimationMove,
                      left: MediaQuery.of(context).size.width / 2,
                      child: Transform.translate(
                        offset: Offset(-(middleMarkerSize / 2), -(middleMarkerSize * 0.8)),
                        child: Icon(
                          Icons.south,
                          size: middleMarkerSize,
                        ),
                      )),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  child: Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: MediaQuery.of(context).size.width / 2,
                      child: FractionalTranslation(
                          translation: Offset(-0.5, -0.5),
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                              BoxShadow(
                                color: Palette.ivoryBlack,
                                blurRadius: 5.0,
                              ),
                            ]),
                            child: Icon(
                              Icons.circle,
                              color: Palette.ivoryBlack,
                              size: 10,
                            ),
                          ))),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(Dimentions.big),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Potwierdź lokalizację',
                            style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          VerticalSizedBox8(),
                          Divider(),
                          VerticalSizedBox8(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.south),
                                  HorizontalSizedBox4(),
                                  Text(
                                    _chaletAddressPlacemark.street.toString(),
                                    style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => navigateToAddressInputScreen(),
                              ),
                            ],
                          ),
                          VerticalSizedBox8(),
                          CustomElevatedButton(
                            label: 'Potwierdź',
                            onPressed: () => navigateBackAndPassChaletLocalization(),
                          )
                        ],
                      ),
                    )),
                if (_isCameraBackToUserLocationBtnActive)
                  Positioned(
                    bottom: MediaQuery.of(context).size.height / 4 + 10.0,
                    right: 0,
                    child: NavigationIconBtn(onPressed: () {
                      _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _initialUserPosition,
                            zoom: _cameraZoom,
                          ),
                        ),
                      );
                      _onCameraIdle();
                    }),
                  )
              ],
            ),
    );
  }
}

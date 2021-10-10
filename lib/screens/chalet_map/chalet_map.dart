import 'dart:async';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_text_button_rounded.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ChaletMap extends StatefulWidget {
  const ChaletMap({
    Key? key,
  }) : super(key: key);

  @override
  _ChaletMapState createState() => _ChaletMapState();
}

class _ChaletMapState extends State<ChaletMap> {
  late LatLng _cameraCenterPosition;
  late GoogleMapController _googleMapController;
  late BehaviorSubject<LatLng> _cameraPositionBehaviourSubject;
  late StreamSubscription<List<ChaletModel>> _chaletStreamSubscribtion;

  List<Marker> markers = [];
  bool _isScreenLoading = true;

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

  void _addMarker(ChaletModel chalet) {
    var _marker = Marker(
      markerId: MarkerId(chalet.id),
      position: getLatLngFromGeoPoint(chalet.position['geopoint']),
      infoWindow: InfoWindow(
        title: '${chalet.name} ${chalet.id}',
        snippet: chalet.rating.toString(),
      ),
    );
    setState(() => markers.add(_marker));
  }

  void _onMapCreated(controller) {
    _googleMapController = controller;
  }

  void _updateQuery(LatLng value) {
    setState(() => _cameraPositionBehaviourSubject.add(value));
  }

  void _updateMarkers(List<ChaletModel> chaletlist) {
    setState(() => markers.clear());
    chaletlist.forEach((chalet) => _addMarker(chalet));
  }

  void _getInitData() async {
    LatLng userLocation = await GeolocationService().getUserLocation();
    _cameraCenterPosition = userLocation;
    _cameraPositionBehaviourSubject = BehaviorSubject<LatLng>.seeded(_cameraCenterPosition);
    _chaletStreamSubscribtion = ChaletService().getChaletStream(_cameraPositionBehaviourSubject, _updateMarkers);
    setState(() {
      _isScreenLoading = false;
    });
  }

  @override
  void initState() {
    _getInitData();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _chaletStreamSubscribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isScreenLoading
        ? Loading()
        : Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _cameraCenterPosition, zoom: 15.0),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  onCameraMove: (pos) => _onCameraMove(pos),
                  myLocationEnabled: true,
                  markers: markers.toSet(),
                ),
                Positioned(
                  top: Dimentions.large,
                  left: MediaQuery.of(context).size.width / 2,
                  child: FractionalTranslation(
                    translation: Offset(-0.5, 0),
                    child: CustomTextButtonRounded(
                      onPressed: () => _updateQuery(_cameraCenterPosition),
                      label: 'Szukaj na tym obszarze',
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(target: _cameraCenterPosition, zoom: 15.0)),
              ),
              child: Icon(Icons.center_focus_strong),
            ),
          );
  }
}

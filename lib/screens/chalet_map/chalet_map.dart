import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/directions_model.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/diretions_repository.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/styles/palette.dart';
import 'package:chalet/widgets/custom_text_button_rounded.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';

class ChaletMap extends StatefulWidget {
  final Function(LatLng) updateQuery;
  const ChaletMap({
    Key? key,
    required this.updateQuery,
  }) : super(key: key);

  @override
  _ChaletMapState createState() => _ChaletMapState();
}

class _ChaletMapState extends State<ChaletMap> with AutomaticKeepAliveClientMixin<ChaletMap> {
  late LatLng _cameraCenterPosition;
  late GoogleMapController _googleMapController;

  List<Marker> markers = [];
  bool _isPanelDraggagle = true;
  ChaletModel? _activeChalet;

  final _panelController = PanelController();
  static const _centerButtonPrimaryHeight = Dimentions.medium;
  static const _navButtonPrimaryHeight = 80.0;
  double _centerButtonHeight = _centerButtonPrimaryHeight;
  double _navigationHeight = _navButtonPrimaryHeight;
  Directions? _directionsInfo;

  bool _isSearchThisAreaButtonActive = false;

  void _handleNavigationButton() async {
    try {
      LatLng _userLocation = context.read<LatLng>();
      final directions = await DirectionsRepository().getDirections(
          origin: _userLocation, destination: getLatLngFromGeoPoint(_activeChalet?.position['geopoint']));
      setState(() {
        _directionsInfo = directions;
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  void _centerCamera() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: context.read<LatLng>(), zoom: 15.0)),
    );
    setState(() => _isSearchThisAreaButtonActive = false);
  }

  void _handleSearchThisAreaButton() {
    widget.updateQuery(_cameraCenterPosition);
    setState(() => _isSearchThisAreaButtonActive = false);
  }

  void _onCameraIdle() {
    if (_activeChalet == null) {
      LatLng _userLocation = context.read<LatLng>();
      if (_cameraCenterPosition.latitude.toStringAsFixed(5) == _userLocation.latitude.toStringAsFixed(5) &&
          _cameraCenterPosition.longitude.toStringAsFixed(5) == _userLocation.longitude.toStringAsFixed(5))
        setState(() => _isSearchThisAreaButtonActive = false);
      else
        setState(() => _isSearchThisAreaButtonActive = true);
    }
  }

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

  void _addMarker(ChaletModel chalet) {
    var _marker = Marker(
        markerId: MarkerId(chalet.id),
        position: getLatLngFromGeoPoint(chalet.position['geopoint']),
        infoWindow: InfoWindow(
          title: '${chalet.name} ${chalet.id}',
          snippet: chalet.rating.toString(),
        ),
        onTap: () {
          if (_activeChalet == null) _panelController.show();
          setState(() {
            _activeChalet = chalet;
            _directionsInfo = null;
          });
        });
    setState(() => markers.add(_marker));
  }

  void _onMapCreated(controller) {
    _googleMapController = controller;
  }

  void _onMapTap(LatLng latlng) {
    if (_activeChalet != null) {
      _panelController.hide();
      setState(() {
        _activeChalet = null;
        _directionsInfo = null;
      });
    }
  }

  void _updateMarkers(List<ChaletModel> chaletlist) {
    setState(() => markers.clear());
    chaletlist.forEach((chalet) => _addMarker(chalet));
  }

  void getInitData() {
    LatLng _location = context.read<LatLng>();
    _cameraCenterPosition = _location;
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final _chaletlist = Provider.of<List<ChaletModel>>(context);
    _updateMarkers(_chaletlist);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _panelHeightClosed = _activeChalet == null ? 0.0 : MediaQuery.of(context).size.height * 0.2;
    final _panelHeightOpen = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            isDraggable: _isPanelDraggagle,
            controller: _panelController,
            minHeight: _panelHeightClosed,
            maxHeight: _panelHeightOpen,
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.0)),
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            color: Palette.backgroundWhite,
            panelBuilder: (controller) => _activeChalet == null
                ? Container()
                : ChaletCard(
                    controller: controller,
                    chalet: _activeChalet,
                    isMapEnabled: false,
                    isGalleryEnabled: true,
                  ),
            onPanelSlide: (pos) {
              final panelMaxScrollExtend = _panelHeightOpen - MediaQuery.of(context).size.height * 0.2;
              double btnHeight = pos * panelMaxScrollExtend + _centerButtonPrimaryHeight;
              if (_activeChalet != null) btnHeight += MediaQuery.of(context).size.height * 0.2;
              double navBtnHeight = pos * panelMaxScrollExtend + _navButtonPrimaryHeight;
              if (_activeChalet != null) navBtnHeight += MediaQuery.of(context).size.height * 0.2;
              setState(() {
                _centerButtonHeight = btnHeight;
                _navigationHeight = navBtnHeight;
              });
            },
            body: GoogleMap(
              initialCameraPosition: CameraPosition(target: _cameraCenterPosition, zoom: 15.0),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              onCameraMove: (pos) => _onCameraMove(pos),
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: true,
              markers: markers.toSet(),
              onTap: _onMapTap,
              polylines: {
                if (_directionsInfo != null)
                  Polyline(
                      polylineId: PolylineId(_activeChalet!.id),
                      color: Palette.chaletBlue,
                      width: 5,
                      points: _directionsInfo!.polylinePoints.map((el) => LatLng(el.latitude, el.longitude)).toList())
              },
            ),
          ),
          if (_isSearchThisAreaButtonActive)
            Positioned(
              // 35 is the height value of tab bar
              top: Dimentions.large + 35,
              left: MediaQuery.of(context).size.width / 2,
              child: FractionalTranslation(
                translation: Offset(-0.5, 0),
                child: CustomTextButtonRounded(
                  onPressed: _handleSearchThisAreaButton,
                  label: 'Szukaj na tym obszarze',
                ),
              ),
            ),
          if (_directionsInfo != null)
            Positioned(
              // 35 is the height value of tab bar
              top: Dimentions.large + 85,
              left: MediaQuery.of(context).size.width / 2,
              child: FractionalTranslation(
                  translation: Offset(-0.5, 0),
                  child: Container(
                    padding: EdgeInsets.all(Dimentions.small),
                    decoration: BoxDecoration(
                        color: Palette.backgroundWhite, borderRadius: new BorderRadius.circular(Dimentions.small)),
                    child: Text(
                      'odległość: ${_directionsInfo!.totalDistance}, czas: ${_directionsInfo!.totalDuration}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Palette.ivoryBlack,
                          ),
                    ),
                  )),
            ),
          Positioned(
            right: Dimentions.medium,
            bottom: _centerButtonHeight,
            child: FloatingActionButton(
              backgroundColor: Palette.chaletBlue,
              foregroundColor: Palette.white,
              onPressed: _centerCamera,
              child: Icon(Icons.center_focus_strong),
            ),
          ),
          Positioned(
            right: Dimentions.medium,
            bottom: _navigationHeight,
            child: FloatingActionButton(
              backgroundColor: Palette.chaletBlue,
              foregroundColor: Palette.white,
              onPressed: _handleNavigationButton,
              child: Icon(Icons.navigation),
            ),
          ),
        ],
      ),
    );
  }
}

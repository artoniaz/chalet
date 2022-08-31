import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_state.dart';
import 'package:chalet/blocs/review/review_bloc.dart';
import 'package:chalet/blocs/review/review_event.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/directions_model.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_text_button_rounded.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';

class ChaletMap extends StatefulWidget {
  final Function(LatLng) updateQuery;
  final BitmapDescriptor chaletLocationIcon;
  const ChaletMap({
    Key? key,
    required this.updateQuery,
    required this.chaletLocationIcon,
  }) : super(key: key);

  @override
  _ChaletMapState createState() => _ChaletMapState();
}

class _ChaletMapState extends State<ChaletMap> with AutomaticKeepAliveClientMixin<ChaletMap> {
  late LatLng _cameraCenterPosition;
  late GoogleMapController _googleMapController;
  late LatLng _userLocation;
  late Set<Circle> mapCenterCircles;

  final markerKey = GlobalKey();

  bool _isPanelDraggagle = true;
  ChaletModel? _activeChalet;

  final _panelController = PanelController();
  static const _addButtonPrimaryHeight = Dimentions.medium;
  static const _centerButtonPrimaryHeight = 80.0;
  static const _centerCircleRadius = 500.0;
  double _addButtonHeight = _addButtonPrimaryHeight + 72.0;
  double _centerButtonHeight = _centerButtonPrimaryHeight + 72.0;
  Directions? _directionsInfo;

  bool _isSearchThisAreaButtonActive = false;

  // temporary removed from the scope
  // void _handleNavigationButton() async {
  //   try {
  //     LatLng _userLocation = context.read<LatLng>();
  //     final directions = await DirectionsRepository().getDirections(
  //         origin: _userLocation, destination: getLatLngFromGeoPoint(_activeChalet?.position['geopoint']));
  //     setState(() {
  //       _directionsInfo = directions;
  //     });
  //   } catch (e) {
  //     EasyLoading.showError(e.toString());
  //   }
  // }

  void _centerCamera() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: _userLocation, zoom: 15.0)),
    );
    setState(() => _cameraCenterPosition = _userLocation);
    removeAreaToLookForCenterCirclePosition();
    _handleSearchThisAreaButton();
  }

  void _handleSearchThisAreaButton() {
    widget.updateQuery(_cameraCenterPosition);
    setState(() => _isSearchThisAreaButtonActive = false);
    updateSearchCenterCirclePosition();
  }

  void _onCameraIdle() {
    if (_activeChalet == null) {
      if (_cameraCenterPosition.latitude.toStringAsFixed(5) == _userLocation.latitude.toStringAsFixed(5) &&
          _cameraCenterPosition.longitude.toStringAsFixed(5) == _userLocation.longitude.toStringAsFixed(5)) {
        setState(() => _isSearchThisAreaButtonActive = false);
      } else {
        setState(() => _isSearchThisAreaButtonActive = true);
      }
    }
  }

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

  List<Marker> _createChaletListMarkers(List<ChaletModel> chaletList) => chaletList
      .map((chalet) => Marker(
            markerId: MarkerId(chalet.id),
            icon: widget.chaletLocationIcon,
            position: getLatLngFromGeoPoint(chalet.position['geopoint']),
            infoWindow: InfoWindow(
              title: '${chalet.name}',
              snippet: 'Ocena: ${chalet.rating.toStringAsFixed(1)}',
            ),
            onTap: () {
              if (_activeChalet == null) _panelController.show();
              setState(() {
                _activeChalet = chalet;
                _directionsInfo = null;
              });
              Provider.of<ReviewBloc>(context, listen: false).add(ResetReviewBloc());
            },
          ))
      .toList();

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

  void updateSearchCenterCirclePosition() {
    mapCenterCircles = Set.from([
      Circle(
        circleId: CircleId('centerCircle'),
        center: _cameraCenterPosition,
        radius: _centerCircleRadius,
        fillColor: Palette.chaletBlue.withOpacity(0.2),
        strokeColor: Palette.chaletBlue,
        strokeWidth: 2,
      )
    ]);
  }

  void removeAreaToLookForCenterCirclePosition() =>
      mapCenterCircles.removeWhere((el) => el.circleId == CircleId('centerAreaToLookForCircle'));

  void updateAreaToLookForCenterCirclePosition() {
    mapCenterCircles.add(Circle(
      circleId: CircleId('centerAreaToLookForCircle'),
      center: _cameraCenterPosition,
      radius: _centerCircleRadius,
      strokeColor: Palette.chaletBlue,
      strokeWidth: 2,
    ));
  }

  void getInitData() async {
    LatLng userLocation = context.read<GeolocationBloc>().state.props.first as LatLng;

    _cameraCenterPosition = userLocation;
    _userLocation = userLocation;

    updateSearchCenterCirclePosition();
  }

  @override
  void initState() {
    getInitData();
    super.initState();
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
    double screenHeight = MediaQuery.of(context).size.height;
    final double _fixedButtonsBottomOffsetHight = 180.0;
    final _panelHeightClosed = _activeChalet == null ? 0.0 : _fixedButtonsBottomOffsetHight;
    final _panelHeightOpen = screenHeight * 0.6;
    return BlocConsumer<GetChaletsBloc, GetChaletsState>(
      listener: (context, chaletsState) {},
      builder: (context, chaletsState) {
        if (chaletsState is GetChaletsStateLoaded) {
          if (_activeChalet != null) {
            ChaletModel? _updatedActiveChalet =
                chaletsState.chaletList.firstWhereOrNull((el) => el.id == _activeChalet!.id);
            _activeChalet = _updatedActiveChalet;
          }
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SlidingUpPanel(
                isDraggable: _isPanelDraggagle,
                controller: _panelController,
                minHeight: _panelHeightClosed,
                maxHeight: _panelHeightOpen,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                color: Palette.backgroundWhite,
                panelBuilder: (controller) => _activeChalet == null
                    ? Container()
                    : Scaffold(
                        backgroundColor: Colors.transparent,
                        body: ChaletCard(
                          controller: controller,
                          chalet: _activeChalet,
                          isMapEnabled: false,
                          isGalleryEnabled: true,
                          userLocation: _userLocation,
                          panelController: _panelController,
                        ),
                        floatingActionButton: _panelController.isAttached && _panelController.isPanelOpen
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimentions.horizontalPadding, vertical: 52.0),
                                    child: AddReviewModule(chalet: _activeChalet!),
                                  ),
                                ],
                              )
                            : Container(),
                        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      ),
                onPanelSlide: (pos) {
                  final panelMaxScrollExtend = _panelHeightOpen - _fixedButtonsBottomOffsetHight;
                  double btnHeight = pos * panelMaxScrollExtend + _addButtonPrimaryHeight + 72.0;
                  if (_activeChalet != null) btnHeight += 82.0 + Dimentions.big;
                  double navBtnHeight = pos * panelMaxScrollExtend + _centerButtonPrimaryHeight + 72.0;
                  if (_activeChalet != null) navBtnHeight += 82.0 + Dimentions.big;
                  setState(() {
                    _addButtonHeight = btnHeight;
                    _centerButtonHeight = navBtnHeight;
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
                  markers: _createChaletListMarkers(chaletsState.chaletList).toSet(),
                  onTap: _onMapTap,
                  circles: mapCenterCircles,
                  polylines: {
                    if (_directionsInfo != null)
                      Polyline(
                          polylineId: PolylineId(_activeChalet!.id),
                          color: Palette.chaletBlue,
                          width: 5,
                          points:
                              _directionsInfo!.polylinePoints.map((el) => LatLng(el.latitude, el.longitude)).toList())
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
                  heroTag: 'chaletMapCenterButton',
                  backgroundColor: Palette.chaletBlue,
                  foregroundColor: Palette.white,
                  onPressed: _centerCamera,
                  child: Icon(Icons.center_focus_strong),
                ),
              ),
              Positioned(
                right: Dimentions.medium,
                bottom: _addButtonHeight,
                child: FloatingActionButton(
                  heroTag: 'chaletMapAddChaletButton',
                  backgroundColor: Palette.chaletBlue,
                  foregroundColor: Palette.white,
                  onPressed: () => Navigator.pushNamed(context, RoutesDefinitions.ADD_CHALET),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        } else
          return Container();
      },
    );
  }
}

import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_event.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_state.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChaletPageSelection extends StatefulWidget {
  const ChaletPageSelection({
    Key? key,
  }) : super(key: key);

  @override
  _ChaletPageSelectionState createState() => _ChaletPageSelectionState();
}

class _ChaletPageSelectionState extends State<ChaletPageSelection> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late BehaviorSubject<LatLng> _cameraPositionBehaviourSubject;
  late BitmapDescriptor _chaletLocationIcon;
  late GetChaletsBloc _getChaletsBloc;

  Future<void> _getBitmapDescriptor() async {
    // final byteData = await rootBundle.load('assets/poo/poo_happy.png');
    // Uint8List image = byteData.buffer.asUint8List();
    // final descriptor = await BitmapDescriptor.fromBytes(image);
    final descriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/map_marker/map_marker.png');
    _chaletLocationIcon = descriptor;
  }

  void _updateCameraPositionBehaviourSubject(LatLng value) {
    setState(() {
      _cameraPositionBehaviourSubject.add(value);
    });
  }

  void _getInitData() async {
    _getChaletsBloc = Provider.of<GetChaletsBloc>(context, listen: false);
    LatLng userLocation = context.read<GeolocationBloc>().state.props.first as LatLng;
    _cameraPositionBehaviourSubject = BehaviorSubject<LatLng>.seeded(userLocation);
    _getChaletsBloc.add(GetChalets(_cameraPositionBehaviourSubject));
    await _getBitmapDescriptor();
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 1);
    _getInitData();

    super.initState();
  }

  @override
  void dispose() {
    _cameraPositionBehaviourSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetChaletsBloc, GetChaletsState>(
      bloc: _getChaletsBloc,
      builder: (context, chaletsState) {
        if (chaletsState is Loading) return Loading();
        if (chaletsState is GetChaletsStateLoaded) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ChaletList(),
                  ChaletMap(
                    updateQuery: _updateCameraPositionBehaviourSubject,
                    chaletLocationIcon: _chaletLocationIcon,
                  ),
                ],
              ),
              Positioned(
                top: Dimentions.small,
                child: SafeArea(
                  child: FlutterToggleTab(
                    width: 100.0 - Dimentions.small,
                    borderRadius: 30.0,
                    height: 35.0,
                    selectedIndex: _tabController.index,
                    selectedTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    unSelectedTextStyle:
                        TextStyle(color: Palette.ivoryBlack, fontSize: 12, fontWeight: FontWeight.w500),
                    selectedBackgroundColors: [Palette.chaletBlue],
                    labels: [
                      "Lista",
                      "Mapa",
                    ],
                    selectedLabelIndex: (index) {
                      setState(() {
                        _tabController.animateTo(index);
                      });
                    },
                  ),
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

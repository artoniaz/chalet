import 'package:Challet/blocs/chalet_icon/chalet_icon_bloc.dart';
import 'package:Challet/blocs/chalet_icon/chalet_icon_event.dart';
import 'package:Challet/blocs/chalet_icon/chalet_icon_state.dart';
import 'package:Challet/blocs/geolocation/geolocation_bloc.dart';
import 'package:Challet/blocs/get_chalets_bloc/get_chalets_bloc.dart';
import 'package:Challet/blocs/get_chalets_bloc/get_chalets_event.dart';
import 'package:Challet/blocs/get_chalets_bloc/get_chalets_state.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/loading.dart';
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
  late GetChaletsBloc _getChaletsBloc;
  late ChaletIconBloc _chaletIconBloc;

  void _updateCameraPositionBehaviourSubject(LatLng value) {
    setState(() {
      _cameraPositionBehaviourSubject.add(value);
    });
  }

  void _getInitData() async {
    _getChaletsBloc = Provider.of<GetChaletsBloc>(context, listen: false);
    _chaletIconBloc = Provider.of<ChaletIconBloc>(context, listen: false);
    LatLng userLocation = context.read<GeolocationBloc>().state.props.first as LatLng;
    _cameraPositionBehaviourSubject = BehaviorSubject<LatLng>.seeded(userLocation);
    _getChaletsBloc.add(GetChalets(_cameraPositionBehaviourSubject));
    _chaletIconBloc.add(GetChaletIcon());
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
    return BlocBuilder<ChaletIconBloc, ChaletIconState>(
      bloc: _chaletIconBloc,
      builder: (context, chaletIconState) {
        return BlocBuilder<GetChaletsBloc, GetChaletsState>(
          bloc: _getChaletsBloc,
          builder: (context, chaletsState) {
            if (chaletsState is GetChaletsStateLoading || chaletIconState is ChaletIconStateLoading) return Loading();
            if (chaletsState is GetChaletsStateLoaded && chaletIconState is ChaletIconStateLoaded) {
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
                        chaletLocationIcon: chaletIconState.chaletIcon,
                      ),
                    ],
                  ),
                  Positioned(
                    top: Dimentions.small,
                    child: SafeArea(
                      child: FlutterToggleTab(
                        width: 100.0 - Dimentions.toggleTabHorizontalPadding,
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
      },
    );
  }
}

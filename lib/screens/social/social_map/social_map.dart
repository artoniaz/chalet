import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SocialMap extends StatefulWidget {
  const SocialMap({Key? key}) : super(key: key);

  @override
  _SocialMapState createState() => _SocialMapState();
}

class _SocialMapState extends State<SocialMap> with AutomaticKeepAliveClientMixin<SocialMap> {
  late LatLng _cameraCenterPosition;
  late GoogleMapController _googleMapController;
  late LatLng _userLocation;

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

  void _onMapCreated(controller) {
    _googleMapController = controller;
  }

  void getInitData() async {
    LatLng userLocation = Provider.of<GeolocationBloc>(context, listen: false).state.props.first as LatLng;
    _cameraCenterPosition = userLocation;
    _userLocation = userLocation;
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _cameraCenterPosition, zoom: 18.0),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            onCameraMove: (pos) => _onCameraMove(pos),
            // onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            // markers: markers.toSet(),
            // onTap: _onMapTap,
          ),
        ],
      ),
    );
  }
}

import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/social_map_chalet_list/social_map_chalet_list_bloc.dart';
import 'package:chalet/blocs/social_map_chalet_list/social_map_chalet_list_event.dart';
import 'package:chalet/blocs/social_map_chalet_list/social_map_chalet_list_state.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late ChaletListForSocialMapBloc _chaletListForSocialMapBloc;
  late List<UserModel> _teamMemberList;

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

  void _onMapCreated(controller) {
    _googleMapController = controller;
  }

  void getInitData() async {
    LatLng userLocation = Provider.of<GeolocationBloc>(context, listen: false).state.props.first as LatLng;
    _chaletListForSocialMapBloc = Provider.of<ChaletListForSocialMapBloc>(context, listen: false);
    _teamMemberList = Provider.of<TeamMembersBloc>(context, listen: false).teamMemberList;
    List<String> _teamMembersIds = _teamMemberList.map((el) => el.uid).toList();

    _chaletListForSocialMapBloc.add(GetChaletListForSocialMap(_teamMembersIds));
    _cameraCenterPosition = userLocation;
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
          BlocBuilder<ChaletListForSocialMapBloc, ChaletListForSocialMapState>(
              bloc: _chaletListForSocialMapBloc,
              builder: (context, state) {
                if (state is ChaletListForSocialMapStateLoaded) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(target: _cameraCenterPosition, zoom: 18.0),
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                    onCameraMove: (pos) => _onCameraMove(pos),
                    markers: state.chaletListMarkers.toSet(),
                    myLocationEnabled: true,
                  );
                } else
                  return Loading();
              }),
        ],
      ),
    );
  }
}

import 'package:Challet/blocs/geolocation/geolocation_bloc.dart';
import 'package:Challet/blocs/social_map_chalet_list/social_map_chalet_list_bloc.dart';
import 'package:Challet/blocs/social_map_chalet_list/social_map_chalet_list_event.dart';
import 'package:Challet/blocs/social_map_chalet_list/social_map_chalet_list_state.dart';
import 'package:Challet/blocs/team_members/team_members_bloc.dart';
import 'package:Challet/models/index.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
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
  late ChaletListForSocialMapBloc _chaletListForSocialMapBloc;
  late List<UserModel> _teamMemberList;

  void _onCameraMove(CameraPosition position) => _cameraCenterPosition = position.target;

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
                    onCameraMove: (pos) => _onCameraMove(pos),
                    markers: state.chaletListMarkers.toSet(),
                    myLocationEnabled: true,
                  );
                } else
                  return Loading();
              }),
          Positioned(
            top: Dimentions.medium,
            left: MediaQuery.of(context).size.width / 2,
            width: MediaQuery.of(context).size.width - 2 * Dimentions.medium,
            child: FractionalTranslation(
              translation: Offset(-0.5, 0),
              child: CustomTextButtonRounded(
                label: 'Wyświetlono najnowsze 8 Szaletów dodanych przez członków klanu',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

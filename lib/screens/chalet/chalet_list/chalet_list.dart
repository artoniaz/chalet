import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_bloc.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_event.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_state.dart';
import 'package:chalet/config/functions/get_distance.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/config/routes/routes_definitions.dart';
import 'package:chalet/screens/chalet/chalet_list/sorting_dropown.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChaletList extends StatefulWidget {
  const ChaletList({Key? key}) : super(key: key);

  @override
  _ChaletListState createState() => _ChaletListState();
}

class _ChaletListState extends State<ChaletList> with AutomaticKeepAliveClientMixin<ChaletList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  late LatLng _userLocation;
  late GetChaletsBloc _getChaletsBloc;

  @override
  void initState() {
    _userLocation = context.read<GeolocationBloc>().state.props.first as LatLng;
    _getChaletsBloc = Provider.of<GetChaletsBloc>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GetChaletsBloc, GetChaletsState>(
        bloc: _getChaletsBloc,
        listener: (context, chaletsState) {
          if (chaletsState is GetChaletsStateSorting) {
            EasyLoading.show();
          } else {
            EasyLoading.dismiss();
          }
        },
        builder: (context, chaletsState) {
          if (chaletsState is GetChaletsStateLoading) return Loading();
          if (chaletsState is GetChaletsStateLoaded) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        Dimentions.verticalPadding,
                        Dimentions.large + 40,
                        Dimentions.verticalPadding,
                        Dimentions.small,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: SortingDropdown(
                          currentSorting: chaletsState.sortingValue,
                          onChanged: (String value) => _getChaletsBloc.add(
                            ChangeChaletsSorting(
                                chaletList: chaletsState.chaletList, userLocation: _userLocation, sortingValue: value),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            LatLng chaletLatLng =
                                getLatLngFromGeoPoint(chaletsState.chaletList[index].position['geopoint']);
                            double distance = getDistance(_userLocation.latitude, _userLocation.longitude,
                                chaletLatLng.latitude, chaletLatLng.longitude);
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(context, RoutesDefinitions.CHALET_DETAILS,
                                  arguments: ChaletDetailsArgs(chalet: chaletsState.chaletList[index])),
                              child: ChaletPreviewContainer(
                                chalet: chaletsState.chaletList[index],
                                distanceToChalet: distance,
                              ),
                            );
                          },
                          childCount: chaletsState.chaletList.length,
                        ))),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 72.0,
                      ),
                    )
                  ],
                ),
                Positioned(
                  right: Dimentions.medium,
                  bottom: Dimentions.medium + 72.0,
                  child: FloatingActionButton(
                    heroTag: 'chaletListAddChaletButton',
                    onPressed: () => Navigator.pushNamed(context, RoutesDefinitions.ADD_CHALET),
                    child: Icon(Icons.add, color: Palette.backgroundWhite),
                    backgroundColor: Palette.chaletBlue,
                    elevation: 2.0,
                  ),
                ),
              ],
            );
          } else
            return Container();
        },
      ),
    );
  }
}

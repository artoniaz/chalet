import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/config/routes/routes_definitions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/chalet/chalet_list/sorting_dropown.dart';
import 'package:chalet/screens/chalet/chalet_list/sorting_values.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  List<ChaletModel> chaletList = [];
  late LatLng _userLocation;
  String _currentSorting = SortingValues.BEST_RATED;

  double _getDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  void _sortChaletsByRatingDesc(List<ChaletModel> chalets) => chalets.sort((a, b) => b.rating.compareTo(a.rating));

  void _sortChaletsByLocationAsc(List<ChaletModel> chalets) {
    return chalets.sort((a, b) {
      LatLng aLatLng = getLatLngFromGeoPoint(a.position['geopoint']);
      LatLng bLatLng = getLatLngFromGeoPoint(b.position['geopoint']);
      return _getDistance(aLatLng.latitude, aLatLng.longitude, _userLocation.latitude, _userLocation.longitude)
          .compareTo(
              _getDistance(bLatLng.latitude, bLatLng.longitude, _userLocation.latitude, _userLocation.longitude));
    });
  }

  void _onSortingChange(String val) {
    setState(() => _currentSorting = val);
    if (val == SortingValues.BEST_RATED) {
      _sortChaletsByRatingDesc(chaletList);
    } else if (val == SortingValues.NEAREST) {
      _sortChaletsByLocationAsc(chaletList);
    } else {}
  }

  void getInitData(bool listen) async {
    List<ChaletModel> chalets = Provider.of<List<ChaletModel>>(context, listen: listen);
    _userLocation = context.read<GeolocationBloc>().state.props.first as LatLng;

    _sortChaletsByRatingDesc(chalets);
    setState(() {
      chaletList = chalets;
    });
  }

  @override
  void didChangeDependencies() {
    getInitData(true);
    super.didChangeDependencies();
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
      body: Stack(
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
                  currentSorting: _currentSorting,
                  onChanged: _onSortingChange,
                )),
              ),
              SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      LatLng chaletLatLng = getLatLngFromGeoPoint(chaletList[index].position['geopoint']);
                      double distance = _getDistance(_userLocation.latitude, _userLocation.longitude,
                          chaletLatLng.latitude, chaletLatLng.longitude);
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, RoutesDefinitions.CHALET_DETAILS,
                            arguments: ChaletDetailsArgs(chalet: chaletList[index])),
                        child: ChaletPreviewContainer(
                          chalet: chaletList[index],
                          distanceToChalet: distance,
                        ),
                      );
                    },
                    childCount: chaletList.length,
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
      ),
    );
  }
}

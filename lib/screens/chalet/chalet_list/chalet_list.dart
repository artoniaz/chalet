import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/config/routes/routes_definitions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
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

  void _sortChaletsByRatingDesc(List<ChaletModel> chalets) => chalets.sort((a, b) => b.rating.compareTo(a.rating));

  void getInitData(bool listen) async {
    List<ChaletModel> chalets = Provider.of<List<ChaletModel>>(context, listen: listen);
    _userLocation = context.read<LatLng>();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutesDefinitions.ADD_CHALET),
        child: Icon(Icons.add, color: Palette.backgroundWhite),
        backgroundColor: Palette.chaletBlue,
        elevation: 2.0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              Dimentions.verticalPadding,
              Dimentions.large + 55,
              Dimentions.verticalPadding,
              Dimentions.small,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Najwyżej oceniane',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Palette.ivoryBlack,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  LatLng chaletLatLng = getLatLngFromGeoPoint(chaletList[index].position['geopoint']);
                  double distance = GeolocatorPlatform.instance.distanceBetween(
                      _userLocation.latitude, _userLocation.longitude, chaletLatLng.latitude, chaletLatLng.longitude);
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
        ],
      ),
    );
  }
}

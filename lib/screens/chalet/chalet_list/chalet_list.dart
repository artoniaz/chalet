import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChaletList extends StatefulWidget {
  const ChaletList({Key? key}) : super(key: key);

  @override
  _ChaletListState createState() => _ChaletListState();
}

class _ChaletListState extends State<ChaletList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<ChaletModel> chaletList = [];
  bool isLoading = true;

  void handleLoadMoreData() async {
    List<ChaletModel> chalets = await ChaletService().getChaletList(lastChalet: chaletList.last) ?? [];
    print(chalets.length);
    setState(() => chaletList += chalets);
  }

  void refetchData() {
    getInitData();
    _refreshController.refreshCompleted();
  }

  void getInitData() async {
    try {
      LatLng userPosition = await GeolocationService().getUserLocation();
      List<ChaletModel> chalets = await ChaletService()
              .getChaletList(lastChalet: null, center: GeoFirePoint(userPosition.latitude, userPosition.longitude)) ??
          [];
      setState(() {
        chaletList = chalets;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      EasyLoading.showError('Błąd pobierania danych');
    }
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final chaletList = Provider.of<List<ChaletModel>>(context);
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: refetchData,
        child: CustomScrollView(
          slivers: [
            CustomAppBars.customSliverAppBarDark(context, 'Chalet list'),
            SliverPadding(
              padding: EdgeInsets.all(Dimentions.verticalPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Najwyżej oceniane',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.backgroundWhite),
                ),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RoutesDefinitions.CHALET_DETAILS,
                        arguments: ChaletDetailsArgs(chalet: chaletList[index])),
                    child: ChaletPreviewContainer(
                      chalet: chaletList[index],
                    ),
                  ),
                  childCount: chaletList.length,
                ))),
            SliverToBoxAdapter(
              child: CustomElevatedButton(
                label: 'więcej',
                onPressed: handleLoadMoreData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

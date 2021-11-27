import 'package:chalet/config/chalet_image_slider_phases.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/styles/palette.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ChaletDetails extends StatefulWidget {
  const ChaletDetails({
    Key? key,
  }) : super(key: key);

  @override
  _ChaletDetailsState createState() => _ChaletDetailsState();
}

class _ChaletDetailsState extends State<ChaletDetails> {
  ChaletModel? _chalet;
  late LatLng _userLocation;
  bool _isScreenLoading = true;
  Widget? _returnPage;

  ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as ChaletDetailsArgs;
    setState(() {
      _chalet = args.chalet;
      _returnPage = args.returnPage;
    });
    super.didChangeDependencies();
  }

  void getInitData() async {
    try {
      final _location = await GeolocationService().getUserLocation();
      setState(() {
        _userLocation = _location;
        _isScreenLoading = false;
      });
    } catch (e) {
      setState(() {
        _isScreenLoading = false;
      });
    }
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _pictureHeight = MediaQuery.of(context).size.height * .5;
    return _isScreenLoading
        ? Loading()
        : Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CustomAppBars.customImageSliderSliverAppBar(
                  _chalet!,
                  _pictureHeight,
                  _returnPage,
                ),
                SliverToBoxAdapter(
                  child: ChaletCard(
                    controller: _controller,
                    chalet: _chalet,
                    isMapEnabled: true,
                    isGalleryEnabled: false,
                    userLocation: _userLocation,
                  ),
                ),
              ],
            ),
          );
  }
}

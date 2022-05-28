import 'package:chalet/blocs/damaging_model/damaging_model_bloc.dart';
import 'package:chalet/blocs/damaging_model/damaging_model_state.dart';
import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/geolocation/geolocation_state.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletDetails extends StatefulWidget {
  const ChaletDetails({
    Key? key,
  }) : super(key: key);

  @override
  _ChaletDetailsState createState() => _ChaletDetailsState();
}

class _ChaletDetailsState extends State<ChaletDetails> {
  ChaletModel? _chalet;
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

  @override
  Widget build(BuildContext context) {
    double _pictureHeight = MediaQuery.of(context).size.height * .5;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          BlocBuilder<DamagingDeviceModelBloc, DamagingDeviceModelState>(
            builder: (context, damagingDeviceModelState) {
              if (damagingDeviceModelState is DamagingDeviceModelStateChecked) {
                return CustomAppBars.customImageSliderSliverAppBar(
                  _chalet!,
                  _pictureHeight,
                  damagingDeviceModelState.isReturnToMapOk ? null : _returnPage,
                );
              } else
                return CustomAppBars.customImageSliderSliverAppBar(
                  _chalet!,
                  _pictureHeight,
                  _returnPage,
                );
            },
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, geoState) {
                if (geoState is GeolocationStateLoading) {
                  return Loading();
                }
                if (geoState is GeolocationStateLoaded) {
                  return ChaletCard(
                    controller: _controller,
                    chalet: _chalet,
                    isMapEnabled: true,
                    isGalleryEnabled: false,
                    userLocation: geoState.userLocation,
                  );
                }
                if (geoState is GeolocationStateError) {
                  return ChaletCard(
                    controller: _controller,
                    chalet: _chalet,
                    isMapEnabled: true,
                    isGalleryEnabled: false,
                    userLocation: geoState.userLocation,
                  );
                } else
                  return Container(
                    child: Text('Coś poszło nie tak.'),
                  );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimentions.medium),
            child: AddReviewModule(chalet: _chalet!),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

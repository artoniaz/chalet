import 'package:chalet/blocs/review/review_bloc.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/models/chalet_model.dart';
import 'package:chalet/screens/chalet/chalet_card/description_card.dart';
import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/review_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChaletCard extends StatefulWidget {
  final ChaletModel? chalet;
  final ScrollController controller;
  final bool isMapEnabled;
  final bool isGalleryEnabled;
  final LatLng userLocation;
  final PanelController? panelController;
  const ChaletCard({
    Key? key,
    required this.controller,
    required this.chalet,
    required this.isMapEnabled,
    required this.isGalleryEnabled,
    required this.userLocation,
    this.panelController,
  }) : super(key: key);

  @override
  _ChaletCardState createState() => _ChaletCardState();
}

class _ChaletCardState extends State<ChaletCard> {
  String _distanceToChalet = '';

  void _getDistanceToChalet() {
    late LatLng chaletLatLng;
    if (widget.chalet!.position.runtimeType == GeoFirePoint) {
      chaletLatLng = getLatLngFromGeoFirePoint(widget.chalet!.position);
    } else {
      chaletLatLng = getLatLngFromGeoPoint(widget.chalet!.position['geopoint']);
    }
    double distance = GeolocatorPlatform.instance.distanceBetween(
        widget.userLocation.latitude, widget.userLocation.longitude, chaletLatLng.latitude, chaletLatLng.longitude);
    setState(() => _distanceToChalet = distance.toStringAsFixed(0));
  }

  void scrollReviewList(GlobalKey itemKey) async {
    await Scrollable.ensureVisible(
      itemKey.currentContext!,
      alignment: 1,
      duration: Duration(
        milliseconds: 400,
      ),
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  void handlePanelToggleView() {
    if (!widget.panelController!.isPanelOpen) widget.panelController!.open();
  }

  @override
  void initState() {
    if (widget.chalet != null) _getDistanceToChalet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chaletConvenienceWidth = (MediaQuery.of(context).size.width - 2 * Dimentions.big - 3 * Dimentions.medium) / 4;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: Dimentions.big,
        left: Dimentions.medium,
        right: Dimentions.medium,
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: widget.panelController == null ? () {} : () => handlePanelToggleView(),
              child: DragHandle(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chalet!.name,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      HorizontalSizedBox4(),
                      if (widget.chalet!.isVerified)
                        Icon(
                          Icons.verified,
                          size: 16.0,
                          color: Palette.chaletBlue,
                        ),
                    ],
                  ),
                ),
                AddReviewModule(
                  chalet: widget.chalet!,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomRatingBarIndicator(
                  rating: widget.chalet!.rating,
                  itemSize: 30.0,
                ),
                HorizontalSizedBox8(),
                Text(
                  '(${widget.chalet!.numberRating} ocen)',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Divider(),
            Text(
              'Odległość $_distanceToChalet m',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            VerticalSizedBox16(),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                Text(
                  widget.chalet!.venueDescription,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                )
              ],
            ),
            if (widget.isGalleryEnabled)
              Column(
                children: [
                  VerticalSizedBox16(),
                  Container(
                      height: 140,
                      child: ImagesHorizontalListView(
                        chalet: widget.chalet!,
                      )),
                ],
              ),
            VerticalSizedBox16(),
            Text(
              'Udogodnienia',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            VerticalSizedBox16(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChaletConvenience(
                  convenienceType: widget.chalet!.is24 ? ConveniencesTypes.is24Green : ConveniencesTypes.is24Red,
                  convenienceScore: widget.chalet!.paper,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.paper,
                  convenienceScore: widget.chalet!.paper,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.clean,
                  convenienceScore: widget.chalet!.clean,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.privacy,
                  convenienceScore: widget.chalet!.privacy,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
              ],
            ),
            VerticalSizedBox16(),
            DescriptionCard(title: 'Dokładny opis jak trafić', description: widget.chalet!.descriptionHowToGet),
            VerticalSizedBox16(),
            Divider(),
            VerticalSizedBox16(),
            RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  children: [
                    TextSpan(
                      text: 'Dodany przez: ',
                    ),
                    TextSpan(text: widget.chalet!.creatorName, style: TextStyle(color: Palette.goldLeaf)),
                  ]),
            ),
            VerticalSizedBox16(),
            // if (widget.isMapEnabled)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Mapa',
            //         style: Theme.of(context).textTheme.headline6!.copyWith(
            //               fontWeight: FontWeight.w700,
            //             ),
            //       ),
            //       VerticalSizedBox8(),
            // Container(
            //   width: double.infinity,
            //   height: 200.0,
            //   child: GoogleMap(
            //       initialCameraPosition: CameraPosition(
            //           target: getLatLngFromGeoPoint(widget.chalet?.position['geopoint']), zoom: 15.0),
            //       markers: <Marker>{
            //         Marker(
            //           markerId: MarkerId(widget.chalet!.id),
            //           position: getLatLngFromGeoPoint(widget.chalet?.position['geopoint']),
            //           infoWindow: InfoWindow(
            //             title: '${widget.chalet?.name} ${widget.chalet?.id}',
            //             snippet: widget.chalet?.rating.toString(),
            //           ),
            //         )
            //       }),
            // ),
            //   ],
            // ),
            Divider(),
            ChaletReviewList(
              chaletId: widget.chalet!.id,
              scrollReviewList: scrollReviewList,
            ),
            VerticalSizedBox24(),
            Divider(),
            CustomElevatedButton(
              label: 'Zgłoś problem',
              onPressed: () => Navigator.pushNamed(context, RoutesDefinitions.SHARE_PROBLEM,
                  arguments: ReportProblemArgs(
                    chaletId: widget.chalet!.id,
                    chaletName: widget.chalet!.name,
                  )),
            ),
            BottomContainer(),
          ],
        ),
      ),
    );
  }
}

import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/chalet_model.dart';
import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletCard extends StatefulWidget {
  final ChaletModel? chalet;
  final ScrollController controller;
  final bool isMapEnabled;
  final bool isGalleryEnabled;
  const ChaletCard({
    Key? key,
    required this.controller,
    required this.chalet,
    required this.isMapEnabled,
    required this.isGalleryEnabled,
  }) : super(key: key);

  @override
  _ChaletCardState createState() => _ChaletCardState();
}

class _ChaletCardState extends State<ChaletCard> {
  bool _isReviewsActive = false;

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

  @override
  void didUpdateWidget(covariant ChaletCard oldWidget) {
    if (oldWidget.chalet?.id != widget.chalet?.id) {
      setState(() => _isReviewsActive = false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final chaletConvenienceWidth = (MediaQuery.of(context).size.width - 2 * Dimentions.big - 2 * Dimentions.medium) / 3;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimentions.big,
        vertical: Dimentions.medium,
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DragHandle(),
            VerticalSizedBox8(),
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
                  chaletId: widget.chalet!.id,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.paper,
                  convenienceScore: widget.chalet!.paper,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
                HorizontalSizedBox16(),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.clean,
                  convenienceScore: widget.chalet!.clean,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
                HorizontalSizedBox16(),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.privacy,
                  convenienceScore: widget.chalet!.privacy,
                  width: chaletConvenienceWidth,
                  size: 36.0,
                ),
              ],
            ),
            VerticalSizedBox16(),
            Text(
              'Dokładny opis jak trafić',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            VerticalSizedBox8(),
            Text(
              widget.chalet!.description!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            VerticalSizedBox16(),
            Text(
              'Opis',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            VerticalSizedBox8(),
            Text(
              widget.chalet!.description!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            VerticalSizedBox16(),
            if (widget.isMapEnabled)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mapa',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  VerticalSizedBox8(),
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
                ],
              ),
            VerticalSizedBox16(),
            if (!_isReviewsActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomElevatedButton(label: 'Pokaż oceny', onPressed: () => setState(() => _isReviewsActive = true)),
                ],
              ),
            if (_isReviewsActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oceny',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  ChaletReviewList(
                    chaletId: widget.chalet!.id,
                    scrollReviewList: scrollReviewList,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

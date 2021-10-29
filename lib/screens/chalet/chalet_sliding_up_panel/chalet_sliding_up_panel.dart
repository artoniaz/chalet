import 'package:chalet/models/chalet_model.dart';
import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletSlidingUpPanel extends StatefulWidget {
  final ChaletModel? chalet;
  final ScrollController controller;
  const ChaletSlidingUpPanel({
    Key? key,
    required this.controller,
    required this.chalet,
  }) : super(key: key);

  @override
  _ChaletSlidingUpPanelState createState() => _ChaletSlidingUpPanelState();
}

class _ChaletSlidingUpPanelState extends State<ChaletSlidingUpPanel> {
  bool _isReviewsActive = false;

  void scrollReviewList(GlobalKey itemKey) async {
    await Scrollable.ensureVisible(itemKey.currentContext!,
        alignment: 1,
        duration: Duration(
          milliseconds: 400,
        ));
  }

  @override
  void didUpdateWidget(covariant ChaletSlidingUpPanel oldWidget) {
    if (oldWidget.chalet?.id != widget.chalet?.id) {
      setState(() => _isReviewsActive = false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final chalet_convenience_width =
        (MediaQuery.of(context).size.width - 2 * Dimentions.big - 2 * Dimentions.medium) / 3;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimentions.big,
        vertical: Dimentions.medium,
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // padding: EdgeInsets.zero,
          children: [
            DragHandle(),
            VerticalSizedBox8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.chalet!.name,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
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
            VerticalSizedBox16(),
            Container(
                height: 140,
                child: ImagesHorizontalListView(
                  chalet: widget.chalet!,
                )),
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
                  width: chalet_convenience_width,
                ),
                HorizontalSizedBox16(),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.clean,
                  convenienceScore: widget.chalet!.clean,
                  width: chalet_convenience_width,
                ),
                HorizontalSizedBox16(),
                ChaletConvenience(
                  convenienceType: ConveniencesTypes.privacy,
                  convenienceScore: widget.chalet!.privacy,
                  width: chalet_convenience_width,
                ),
              ],
            ),
            VerticalSizedBox16(),
            Text(
              'Opis',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              widget.chalet!.description!,
              style: Theme.of(context).textTheme.bodyText2,
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
                    style: Theme.of(context).textTheme.headline6,
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

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

  @override
  void didUpdateWidget(covariant ChaletSlidingUpPanel oldWidget) {
    if (oldWidget.chalet?.id != widget.chalet?.id) {
      setState(() => _isReviewsActive = false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimentions.big, vertical: Dimentions.small),
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.zero,
        children: [
          DragHandle(),
          VerticalSizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.chalet!.name,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Row(
                children: [
                  CustomElevatedButtonMinor(
                    label: 'Nawiguj',
                    onPressed: () => print('nawiguj'),
                  ),
                  HorizontalSizedBox8(),
                  AddReviewModule(
                    chaletId: widget.chalet!.id,
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.chalet!.rating.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              HorizontalSizedBox4(),
              Icon(
                Icons.star,
                color: Palette.goldLeaf,
                size: 20.0,
              ),
            ],
          ),
          VerticalSizedBox8(),
          Container(
              height: 180,
              child: ImagesHorizontalListView(
                chalet: widget.chalet!,
              )),
          VerticalSizedBox16(),
          Text(
            'Udogodnienia',
            style: Theme.of(context).textTheme.headline6,
          ),
          Row(
            children: [
              ChaletConvenience(
                convenienceType: ConveniencesTypes.paper,
                convenienceScore: widget.chalet!.paper,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.clean,
                convenienceScore: widget.chalet!.clean,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.quality,
                convenienceScore: widget.chalet!.quality,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.privacy,
                convenienceScore: widget.chalet!.privacy,
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
                ChaletReviewList(chaletId: widget.chalet!.id),
              ],
            ),
        ],
      ),
    );
  }
}

import 'package:chalet/models/chalet_model.dart';
import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ChaletSlidingUpPanel extends StatelessWidget {
  final ChaletModel? chalet;
  final ScrollController controller;
  const ChaletSlidingUpPanel({
    Key? key,
    required this.controller,
    required this.chalet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimentions.big, vertical: Dimentions.small),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: [
          DragHandle(),
          VerticalSizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chalet!.name,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Row(
                children: [
                  CustomElevatedButtonMinor(
                    label: 'Nawiguj',
                    onPressed: () => print('fsbggd'),
                  ),
                  HorizontalSizedBox8(),
                  CustomElevatedButton(
                    label: 'Oceń',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                chalet!.rating.toString(),
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
                chalet: chalet!,
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
                convenienceScore: chalet!.paper,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.clean,
                convenienceScore: chalet!.clean,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.quality,
                convenienceScore: chalet!.quality,
              ),
              HorizontalSizedBox16(),
              ChaletConvenience(
                convenienceType: ConveniencesTypes.privacy,
                convenienceScore: chalet!.privacy,
              ),
            ],
          ),
          VerticalSizedBox16(),
          Text(
            'Opis',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            chalet!.description!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}

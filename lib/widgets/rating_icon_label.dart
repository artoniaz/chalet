import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class RatingIconLabel extends StatelessWidget {
  final double ratingLabel;
  const RatingIconLabel({
    Key? key,
    required this.ratingLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Palette.goldLeaf,
        ),
        HorizontalSizedBox4(),
        Text(
          ratingLabel.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Palette.backgroundWhite),
        )
      ],
    );
  }
}

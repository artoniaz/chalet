import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarItem extends StatelessWidget {
  final Function(double) handleRatingUpdate;
  const RatingBarItem({
    Key? key,
    required this.handleRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        initialRating: 0.0,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Palette.goldLeaf,
            ),
        onRatingUpdate: (rating) => handleRatingUpdate(rating));
  }
}

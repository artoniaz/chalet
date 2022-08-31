import 'package:Challet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBarIndicator extends StatelessWidget {
  final double rating;
  final double itemSize;
  const CustomRatingBarIndicator({
    Key? key,
    required this.rating,
    this.itemSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        rating: rating,
        itemSize: itemSize,
        itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Palette.goldLeaf,
            ));
  }
}

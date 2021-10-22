import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class RatingBarCol extends StatelessWidget {
  final String label;
  final Function(double) handleRatingUpdate;
  const RatingBarCol({
    Key? key,
    required this.label,
    required this.handleRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.start,
        ),
        RatingBarItem(
          handleRatingUpdate: handleRatingUpdate,
        ),
      ],
    );
  }
}

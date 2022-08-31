import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class RatingBarRow extends StatelessWidget {
  final String label;
  final Function(double) handleRatingUpdate;

  const RatingBarRow({
    Key? key,
    required this.label,
    required this.handleRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Palette.ivoryBlack,
                )),
        RatingBarItem(
          handleRatingUpdate: handleRatingUpdate,
        ),
      ],
    );
  }
}

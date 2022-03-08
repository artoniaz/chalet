import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class NotAllowedDialog extends StatelessWidget {
  final double chaletRating;

  const NotAllowedDialog({
    Key? key,
    required this.chaletRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Oceniłeś ten szalet!',
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            VerticalSizedBox16(),
            Text(
              'Twoja dzisiejsza ocena',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            CustomRatingBarIndicator(
              rating: chaletRating,
              itemSize: 30.0,
            ),
            VerticalSizedBox16(),
            Text(
              'Szalet możesz ocenić raz dziennie',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            VerticalSizedBox24(),
            CustomTextButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'zamknij',
              color: Palette.ivoryBlack,
            ),
          ],
        ),
      ),
    );
  }
}

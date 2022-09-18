import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class QuickRatingDialogConfirm extends StatelessWidget {
  final double chaletRating;
  final Function goToFullReview;
  const QuickRatingDialogConfirm({
    Key? key,
    required this.chaletRating,
    required this.goToFullReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                VerticalSizedBox24(),
                ButtonsPopUpRow(
                  approveButtonLabel: 'Powiedz nam więcej',
                  onPressedApproveButton: goToFullReview,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: FractionalTranslation(
              translation: Offset(0, -0.6),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Palette.backgroundWhite,
                  shape: BoxShape.circle,
                ),
                child: Image(
                  width: 80.0,
                  height: 80.0,
                  image: AssetImage('assets/poo/poo_happy.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

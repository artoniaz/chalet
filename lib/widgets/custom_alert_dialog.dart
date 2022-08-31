import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String headline;
  final String? text;
  final String approveFunctionButtonLabel;
  final Function approveFunction;
  const CustomAlertDialog({
    Key? key,
    required this.headline,
    this.text,
    required this.approveFunction,
    required this.approveFunctionButtonLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            color: Palette.backgroundWhite,
            padding: EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headline,
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                VerticalSizedBox16(),
                Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                VerticalSizedBox24(),
                ButtonsPopUpRow(
                  approveButtonLabel: approveFunctionButtonLabel,
                  onPressedApproveButton: () {
                    approveFunction();
                    Navigator.of(context).pop();
                  },
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

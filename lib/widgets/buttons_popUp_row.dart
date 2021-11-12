import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ButtonsPopUpRow extends StatelessWidget {
  final Function onPressedApproveButton;
  final String approveButtonLabel;
  const ButtonsPopUpRow({
    Key? key,
    required this.approveButtonLabel,
    required this.onPressedApproveButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        CustomTextButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'zamknij',
          color: Palette.ivoryBlack,
        ),
        CustomElevatedButton(
          label: approveButtonLabel,
          onPressed: onPressedApproveButton,
        ),
      ],
    );
  }
}

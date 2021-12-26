import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ButtonsPopUpRow extends StatelessWidget {
  final Function? onPressedApproveButton;
  final String approveButtonLabel;
  const ButtonsPopUpRow({
    Key? key,
    required this.approveButtonLabel,
    required this.onPressedApproveButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'zamknij',
          color: Palette.ivoryBlack,
        ),
        Expanded(
          child: CustomElevatedButton(
            label: approveButtonLabel,
            onPressed: onPressedApproveButton,
          ),
        ),
      ],
    );
  }
}

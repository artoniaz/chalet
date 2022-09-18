import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomBackLeadingButton extends StatelessWidget {
  final Widget? returnPage;
  const CustomBackLeadingButton({
    Key? key,
    this.returnPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        padding: EdgeInsets.all(4.0),
        constraints: BoxConstraints(minWidth: 0),
        onPressed: () {
          returnPage != null
              ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => returnPage!), (route) => false)
              : Navigator.of(context).pop();
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 2.0,
        fillColor: Palette.backgroundWhite,
        child: Center(
          child: Icon(
            Icons.arrow_back,
            size: 32.0,
            color: Colors.black,
          ),
        ),
        shape: CircleBorder(),
      ),
    );
  }
}

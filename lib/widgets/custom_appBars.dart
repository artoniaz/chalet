import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomAppBars {
  static AppBar customAppBarDark(
    BuildContext context,
    String label,
  ) =>
      AppBar(
        title: Text(
          label,
          style: Theme.of(context).textTheme.headline3!.copyWith(color: Palette.backgroundWhite),
        ),
      );

  static SliverAppBar customSliverAppBarDark(
    BuildContext context,
    String label,
  ) =>
      SliverAppBar(
        forceElevated: true,
        floating: true,
        elevation: 5.0,
        title: Text(
          label,
          style: Theme.of(context).textTheme.headline3!.copyWith(color: Palette.backgroundWhite),
        ),
      );

  static AppBar customTransparentAppBar(BuildContext context) => AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leadingWidth: 72.0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 2.0,
          fillColor: Colors.white,
          child: Center(
            child: Icon(
              Icons.arrow_back,
              size: 32.0,
              color: Colors.black,
            ),
          ),
          shape: CircleBorder(),
        ),
      ));
}

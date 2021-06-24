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
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Palette.white),
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
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Palette.white),
        ),
      );
}

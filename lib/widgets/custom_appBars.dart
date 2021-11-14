import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
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
        leading: CustomRoundedIconButton(
          onPressed: () => Navigator.of(context).pop(),
          iconData: Icons.arrow_back,
          iconSize: 32.0,
        ),
      );

  static SliverAppBar customImageSliderSliverAppBar(ChaletModel chalet, double pictureHeight) => SliverAppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 72.0,
        leading: CustomBackLeadingButton(),
        elevation: 0,
        expandedHeight: pictureHeight,
        floating: false,
        pinned: false,
        snap: false,
        stretch: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          stretchModes: [StretchMode.zoomBackground],
          background: ChaletDetailsImageCarusel(
            chalet: chalet,
          ),
        ),
      );
}

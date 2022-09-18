import 'package:chalet/config/index.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class CustomAppBars {
  static AppBar customAppBarChaletBlue(
    BuildContext context,
    String label,
  ) =>
      AppBar(
        backgroundColor: Palette.chaletBlue,
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
        leading: CustomBackLeadingButton(),
      );

  static SliverAppBar customImageSliderSliverAppBar(ChaletModel chalet, double pictureHeight, [Widget? returnPage]) =>
      SliverAppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 72.0,
        leading: CustomBackLeadingButton(
          returnPage: returnPage,
        ),
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

  static AppBar customPendingTeamInfoAppBar(
    BuildContext context,
  ) =>
      AppBar(
        backgroundColor: Palette.chaletBlue,
        bottom: PreferredSize(
            child: Container(
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, RoutesDefinitions.VIEW_PENDING_INVITATIONS),
                textColor: Palette.white,
                leading: Icon(
                  Icons.info,
                  color: Palette.white,
                ),
                title: Text(
                  'Masz zaproszenie do klanu',
                ),
                // subtitle: Text('Odpowiedz w zakładce Mój profil'),
                subtitle: RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(
                              color: Palette.white,
                            ),
                        children: [
                      TextSpan(text: 'Odpowiedz w zakładce '),
                      TextSpan(text: 'Mój profil', style: TextStyle(decoration: TextDecoration.underline)),
                    ])),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 16)),
      );
}

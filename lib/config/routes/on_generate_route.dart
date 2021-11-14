import 'package:chalet/config/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Route<dynamic>? Function(RouteSettings)? onGenerateRoute() => (settings) {
      switch (settings.name) {
        case RoutesDefinitions.CHALET_DETAILS:
          return PageTransition(child: ChaletDetails(), type: PageTransitionType.rightToLeft, settings: settings);
        case RoutesDefinitions.ADD_CHALET:
          return PageTransition(child: AddChaletRoot(), type: PageTransitionType.fade, settings: settings);
        default:
          return null;
      }
    };

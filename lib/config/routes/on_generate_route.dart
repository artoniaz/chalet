import 'package:Challet/config/index.dart';
import 'package:Challet/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Route<dynamic>? Function(RouteSettings)? onGenerateRoute() => (settings) {
      switch (settings.name) {
        case RoutesDefinitions.CHALET_DETAILS:
          return PageTransition(child: ChaletDetails(), type: PageTransitionType.rightToLeft, settings: settings);
        case RoutesDefinitions.ADD_CHALET:
          return PageTransition(child: AddChaletRoot(), type: PageTransitionType.fade, settings: settings);
        case RoutesDefinitions.SHARE_PROBLEM:
          return PageTransition(child: ReportProblem(), type: PageTransitionType.rightToLeft, settings: settings);
        case RoutesDefinitions.VIEW_PENDING_INVITATIONS:
          return PageTransition(child: PendingInvitations(), type: PageTransitionType.rightToLeft, settings: settings);
        case RoutesDefinitions.OTHER_USER_PROFILE:
          return PageTransition(child: OtherUserProfile(), type: PageTransitionType.rightToLeft, settings: settings);
        default:
          return null;
      }
    };

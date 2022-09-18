import 'package:chalet/models/index.dart';
import 'package:flutter/material.dart';

class ChaletDetailsArgs {
  final ChaletModel chalet;
  final Widget? returnPage;
  ChaletDetailsArgs({
    required this.chalet,
    this.returnPage,
  });
}

class ReportProblemArgs {
  final String chaletId;
  final String chaletName;
  ReportProblemArgs({
    required this.chaletId,
    required this.chaletName,
  });
}

class UserModelArg {
  final UserModel userModel;
  UserModelArg({
    required this.userModel,
  });
}

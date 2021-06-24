import 'package:flutter/material.dart';

void dissmissCurrentFocus(BuildContext context) {
  print('dis');
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

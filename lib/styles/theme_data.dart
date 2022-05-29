import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

ThemeData themeData() => ThemeData(
      primaryColor: Palette.darkBlue,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Palette.goldLeaf),
      scaffoldBackgroundColor: Palette.backgroundWhite,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Palette.darkBlue,
      ),
      textTheme: textTheme(),
      hintColor: Palette.grey.withOpacity(0.5),
    );

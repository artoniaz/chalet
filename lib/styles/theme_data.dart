import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

ThemeData themeData() => ThemeData(
      primaryColor: Palette.darkBlue,
      accentColor: Palette.goldLeaf,
      scaffoldBackgroundColor: Palette.skyBlue,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Palette.darkBlue,
      ),
      textTheme: textTheme(),
    );

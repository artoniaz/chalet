import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(Dimentions.medium),
    fillColor: Palette.veryLightGrey,
    filled: true,
    border: UnderlineInputBorder(
        borderSide: BorderSide(
      color: Palette.backgroundWhite,
      width: 1.0,
    )),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
      color: Palette.chaletBlue,
      width: 1.0,
    )),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.goldLeaf,
      width: 1.0,
    )),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.goldLeaf,
      width: 1.0,
    )),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.errorRed,
      width: 1.0,
    )));

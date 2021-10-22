import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(Dimentions.small),
    fillColor: Palette.white,
    filled: true,
    border: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.white,
      width: 2.0,
    )),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.white,
      width: 2.0,
    )),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.goldLeaf,
      width: 2.0,
    )),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.goldLeaf,
      width: 2.0,
    )),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Palette.errorRed,
      width: 2.0,
    )));

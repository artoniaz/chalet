import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletIconService {
  Future<BitmapDescriptor> getBitmapDescriptor() async {
    try {
      // final byteData = await rootBundle.load('assets/poo/poo_happy.png');
      // Uint8List image = byteData.buffer.asUint8List();
      // final descriptor = await BitmapDescriptor.fromBytes(image);
      return await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'assets/map_marker/map_marker.png');
    } catch (e) {
      print('Nieudane ładowania znacznika Szaltu na mapie. Zastosowano standardowe znaczniki.');
      return BitmapDescriptor.defaultMarker;
    }
  }
}

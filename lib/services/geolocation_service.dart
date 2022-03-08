import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GeolocationService extends ChangeNotifier {
  final geo = GeolocatorPlatform.instance;

  Future<LatLng> getUserLocation() async {
    try {
      Position pos =
          await geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(const Duration(seconds: 5));
      return LatLng(pos.latitude, pos.longitude);
    } on TimeoutException catch (e) {
      print(e);
      throw 'Połączenie z internetem nie pozwoliło na dokładne pobranie Twojej pozycji.';
    } catch (e) {
      print(e);
      throw 'Nie ustalono pozycji użytkownika';
    }
  }

  Stream<LatLng> get currentUserLocation => geo
      .getPositionStream(desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
      .map((el) => LatLng(el.latitude, el.longitude));

  Future<List<Placemark>> getAddressfromCoords(LatLng cords) async {
    try {
      return await placemarkFromCoordinates(cords.latitude, cords.longitude);
    } catch (e) {
      print(e);
      EasyLoading.show(status: 'Nie udało się pobrać adresu na podstawie podanych koordynatów');
      throw 'Nie udało się pobrać adresu na podstawie podanych koordynatów';
    }
  }

  Future<List<Location>> getLocationFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      print(e);
      throw 'Nie udało się znaleźć lokalizacji na podstawie podanego adresu';
    }
  }

  double getDistanceBetweenPoints(LatLng userLatLng, LatLng chaletLatLng) =>
      geo.distanceBetween(userLatLng.latitude, userLatLng.longitude, chaletLatLng.latitude, chaletLatLng.longitude);
}

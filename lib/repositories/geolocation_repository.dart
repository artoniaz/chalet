import 'package:chalet/services/geolocation_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationRepository {
  final _geolocationService = GeolocationService();
  Future<LatLng> getUserLocation() => _geolocationService.getUserLocation();
}

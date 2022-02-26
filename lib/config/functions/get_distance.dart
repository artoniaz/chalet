import 'package:geolocator/geolocator.dart';

double getDistance(
  double startLatitude,
  double startLongitude,
  double endLatitude,
  double endLongitude,
) =>
    GeolocatorPlatform.instance.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

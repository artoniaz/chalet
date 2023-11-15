import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool compareLatLng(LatLng a, LatLng b) =>
    a.latitude.toStringAsFixed(6) == b.latitude.toStringAsFixed(6) &&
    a.longitude.toStringAsFixed(6) == b.longitude.toStringAsFixed(6);

GeoFirePoint getGeoFirePointFromLatLng(LatLng pos) => GeoFirePoint(pos.latitude, pos.longitude);

LatLng getLatLngFromGeoPoint(GeoPoint geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude);

LatLng getLatLngFromGeoFirePoint(GeoFirePoint geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude);

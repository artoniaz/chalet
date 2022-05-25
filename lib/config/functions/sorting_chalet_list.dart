import 'package:chalet/config/functions/get_distance.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/index.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void sortChaletsByRatingDesc(List<ChaletModel> chalets) => chalets.sort((a, b) => b.rating.compareTo(a.rating));

void sortChaletsByLocationAsc(List<ChaletModel> chalets, LatLng userLocation) {
  return chalets.sort((a, b) {
    LatLng aLatLng = getLatLngFromGeoPoint(a.position['geopoint']);
    LatLng bLatLng = getLatLngFromGeoPoint(b.position['geopoint']);
    return getDistance(aLatLng.latitude, aLatLng.longitude, userLocation.latitude, userLocation.longitude)
        .compareTo(getDistance(bLatLng.latitude, bLatLng.longitude, userLocation.latitude, userLocation.longitude));
  });
}

void sortChaletsByIs24(List<ChaletModel> chalets) => chalets.sort((a, b) => b.is24 ? 1 : -1);

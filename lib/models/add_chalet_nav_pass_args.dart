import 'package:chalet/screens/chalet_map/add_chalet_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddChaletNavigationPassingArgs {
  final LatLng chaletLocalization;
  final Placemark chaletAddress;

  AddChaletNavigationPassingArgs({required this.chaletLocalization, required this.chaletAddress});
}

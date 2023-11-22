import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeolocationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserGeolocation extends GeolocationEvent {
  final bool hasUserSeenLocationInfoScreen;
  GetUserGeolocation({required this.hasUserSeenLocationInfoScreen});
}

class UpdateUserGeolocation extends GeolocationEvent {
  final LatLng userGeolocation;
  UpdateUserGeolocation(this.userGeolocation);

  @override
  List<Object> get props => [userGeolocation];
}

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationState extends Equatable {
  GeolocationState();

  @override
  List<Object> get props => [];
}

class GeolocationStateInitial extends GeolocationState {}

class GeolocationStateLoading extends GeolocationState {}

class GeolocationStateLoaded extends GeolocationState {
  final LatLng userLocation;
  GeolocationStateLoaded({required this.userLocation});
  @override
  List<Object> get props => [userLocation];
}

class GeolocationStateError extends GeolocationState {
  final String errorMessage;
  final LatLng userLocation;
  @override
  List<Object> get props => [userLocation];
  GeolocationStateError({required this.errorMessage, required this.userLocation});
}

class GeolocationStateInfoScreen extends GeolocationState {}

import 'package:chalet/blocs/geolocation/geolocation_event.dart';
import 'package:chalet/blocs/geolocation/geolocation_state.dart';
import 'package:chalet/repositories/geolocation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository geolocationRepository;
  GeolocationBloc({required this.geolocationRepository}) : super(GeolocationStateInitial());

  GeolocationState get initialState => GeolocationStateInitial();

  @override
  void onTransition(Transition<GeolocationEvent, GeolocationState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is GetUserGeolocation) {
      yield* _handleGetUserLocalization(event);
    }
  }

  Stream<GeolocationState> _handleGetUserLocalization(GetUserGeolocation event) async* {
    yield GeolocationStateLoading();
    try {
      LatLng _userLocation = await geolocationRepository.getUserLocation();
      yield GeolocationStateLoaded(userLocation: _userLocation);
    } catch (e) {
      yield GeolocationStateError(errorMessage: e.toString(), userLocation: LatLng(52.237049, 21.017532));
    }
  }
}

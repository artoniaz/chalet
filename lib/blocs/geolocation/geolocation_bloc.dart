import 'dart:async';

import 'package:chalet/blocs/geolocation/geolocation_event.dart';
import 'package:chalet/blocs/geolocation/geolocation_state.dart';
import 'package:chalet/repositories/geolocation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository geolocationRepository;
  GeolocationBloc({required this.geolocationRepository}) : super(GeolocationStateInitial());
  StreamSubscription? userLocationSubscription;

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
    if (event is UpdateUserGeolocation) {
      yield* _handleUpdateUserLocalization(event);
    }
  }

  Stream<GeolocationState> _handleGetUserLocalization(GetUserGeolocation event) async* {
    userLocationSubscription?.cancel();
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      yield GeolocationStateError(
          errorMessage: 'Lokalizacja na tym urządzeniu jest wyłaczona.', userLocation: LatLng(52.237049, 21.017532));
    }
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        yield GeolocationStateError(errorMessage: 'Domyślna lokalizacja', userLocation: LatLng(52.237049, 21.017532));
      }
    }
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      userLocationSubscription = geolocationRepository.getUserLocation().listen(
        (userLocation) => add(UpdateUserGeolocation(userLocation)),
        onError: (e) async* {
          yield GeolocationStateError(
              errorMessage: 'Błąd pobierania listy wydarzeń dla klanu', userLocation: LatLng(52.237049, 21.017532));
        },
      );
    }
  }

  Stream<GeolocationState> _handleUpdateUserLocalization(UpdateUserGeolocation event) async* {
    yield GeolocationStateLoaded(userLocation: event.userGeolocation);
  }

  // working but static call. Not stream
  // Stream<GeolocationState> _handleGetUserLocalization(GetUserGeolocation event) async* {
  //   yield GeolocationStateLoading();
  //   try {
  //     LatLng _userLocation = await geolocationRepository.getUserLocation();
  //     yield GeolocationStateLoaded(userLocation: _userLocation);
  //   } catch (e) {
  //     yield GeolocationStateError(errorMessage: e.toString(), userLocation: LatLng(52.237049, 21.017532));
  //   }
  // }
}

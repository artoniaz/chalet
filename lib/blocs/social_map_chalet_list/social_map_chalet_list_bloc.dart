import 'dart:async';
import 'package:chalet/blocs/social_map_chalet_list/social_map_chalet_list_event.dart';
import 'package:chalet/blocs/social_map_chalet_list/social_map_chalet_list_state.dart';
import 'package:chalet/config/functions/lat_lng_functions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/repositories/chalet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletListForSocialMapBloc extends Bloc<ChaletListForSocialMapEvent, ChaletListForSocialMapState> {
  final ChaletRepository chaletRepository;

  ChaletListForSocialMapBloc({required this.chaletRepository}) : super(ChaletListForSocialMapStateInitial());

  StreamSubscription? chaletListForSocialMapSubscription;

  ChaletListForSocialMapState get initialState => ChaletListForSocialMapStateInitial();

  @override
  void onTransition(Transition<ChaletListForSocialMapEvent, ChaletListForSocialMapState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ChaletListForSocialMapState> mapEventToState(ChaletListForSocialMapEvent event) async* {
    if (event is GetChaletListForSocialMap) {
      yield* _handleGetChaletListForSocialMap(event);
    }
    if (event is UpdateChaletListForSocialMap) {
      yield* _handleUpdateChaletListForSocialMap(event);
    }
  }

  Stream<ChaletListForSocialMapState> _handleGetChaletListForSocialMap(GetChaletListForSocialMap event) async* {
    chaletListForSocialMapSubscription?.cancel();
    chaletListForSocialMapSubscription = chaletRepository.getChaletListAddedByUsers(event.teamMembersIds).listen(
      (chaletList) => add(UpdateChaletListForSocialMap(chaletList)),
      onError: (e) async* {
        yield ChaletListForSocialMapStateError(errorMessage: 'Błąd pobierania listy szaletów dla klanu.');
      },
    );
  }

  Stream<ChaletListForSocialMapState> _handleUpdateChaletListForSocialMap(UpdateChaletListForSocialMap event) async* {
    final List<Marker> chaletListMarkers = event.chaletListForSocialMap
        .map((chalet) => Marker(
              markerId: MarkerId(chalet.id),
              icon: BitmapDescriptor.defaultMarker,
              position: getLatLngFromGeoPoint(chalet.position['geopoint']),
              infoWindow: InfoWindow(
                title: chalet.name,
                snippet: chalet.creatorName,
              ),
            ))
        .toList();

    yield ChaletListForSocialMapStateLoaded(
      chaletList: event.chaletListForSocialMap,
      chaletListMarkers: chaletListMarkers,
    );
  }
}

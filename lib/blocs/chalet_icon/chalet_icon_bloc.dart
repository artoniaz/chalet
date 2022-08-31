import 'dart:async';

import 'package:Challet/blocs/chalet_icon/chalet_icon_event.dart';
import 'package:Challet/blocs/chalet_icon/chalet_icon_state.dart';
import 'package:Challet/repositories/chalet_icon_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletIconBloc extends Bloc<ChaletIconEvent, ChaletIconState> {
  final ChaletIconRepository chaletIconRepository;

  ChaletIconBloc({required this.chaletIconRepository}) : super(ChaletIconStateInitial());

  ChaletIconState get initialState => ChaletIconStateInitial();

  @override
  void onTransition(Transition<ChaletIconEvent, ChaletIconState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ChaletIconState> mapEventToState(ChaletIconEvent event) async* {
    if (event is GetChaletIcon) {
      yield* _handleGetChaletIcon(event);
    }
  }

  Stream<ChaletIconState> _handleGetChaletIcon(GetChaletIcon event) async* {
    yield ChaletIconStateLoading();
    BitmapDescriptor chaletIcon = await chaletIconRepository.getBitmapDescriptor();
    yield ChaletIconStateLoaded(chaletIcon: chaletIcon);
  }
}

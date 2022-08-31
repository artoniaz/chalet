import 'package:Challet/models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletListForSocialMapState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChaletListForSocialMapStateInitial extends ChaletListForSocialMapState {}

class ChaletListForSocialMapStateLoading extends ChaletListForSocialMapState {}

class ChaletListForSocialMapStateLoaded extends ChaletListForSocialMapState {
  final List<ChaletModel> chaletList;
  final List<Marker> chaletListMarkers;
  ChaletListForSocialMapStateLoaded({
    required this.chaletList,
    required this.chaletListMarkers,
  });

  @override
  List<Object> get props => [chaletList];
}

class ChaletListForSocialMapStateError extends ChaletListForSocialMapState {
  final String errorMessage;
  ChaletListForSocialMapStateError({required this.errorMessage});
}

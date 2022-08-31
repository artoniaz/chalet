import 'package:Challet/models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetChaletsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetChalets extends GetChaletsEvent {
  final BehaviorSubject<LatLng> subject;
  GetChalets(
    this.subject,
  );
}

class UpdateChalets extends GetChaletsEvent {
  final List<ChaletModel> chaletList;
  UpdateChalets(
    this.chaletList,
  );

  @override
  List<Object> get props => [chaletList];
}

class ChangeChaletsSorting extends GetChaletsEvent {
  final List<ChaletModel> chaletList;
  final String sortingValue;
  final LatLng userLocation;
  ChangeChaletsSorting({
    required this.chaletList,
    required this.userLocation,
    required this.sortingValue,
  });
}

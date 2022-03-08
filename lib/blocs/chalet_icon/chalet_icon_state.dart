import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletIconState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChaletIconStateInitial extends ChaletIconState {}

class ChaletIconStateLoading extends ChaletIconState {}

class ChaletIconStateLoaded extends ChaletIconState {
  final BitmapDescriptor chaletIcon;
  ChaletIconStateLoaded({required this.chaletIcon});

  @override
  List<Object> get props => [chaletIcon];
}

class ChaletIconStateError extends ChaletIconState {
  final String errorMessage;
  ChaletIconStateError({required this.errorMessage});
}

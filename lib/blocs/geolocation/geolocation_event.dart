import 'package:equatable/equatable.dart';

abstract class GeolocationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserGeolocation extends GeolocationEvent {}

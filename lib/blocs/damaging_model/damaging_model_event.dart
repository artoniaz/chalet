import 'package:equatable/equatable.dart';

abstract class DamagingDeviceModelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckDamagingDeviceModelEvent extends DamagingDeviceModelEvent {
  CheckDamagingDeviceModelEvent();
}

import 'package:equatable/equatable.dart';

class DamagingDeviceModelState extends Equatable {
  DamagingDeviceModelState();

  @override
  List<Object> get props => [];
}

class DamagingDeviceModelStateInitial extends DamagingDeviceModelState {}

class DamagingDeviceModelStateChecked extends DamagingDeviceModelState {
  final bool isImagePickerOk;
  final bool isReturnToMapOk;
  DamagingDeviceModelStateChecked({
    required this.isImagePickerOk,
    required this.isReturnToMapOk,
  });
}

class DamagingDeviceModelStateError extends DamagingDeviceModelState {
  final String errorMessage;
  DamagingDeviceModelStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

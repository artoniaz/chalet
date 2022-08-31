import 'dart:io';

import 'package:Challet/blocs/damaging_model/damaging_model_event.dart';
import 'package:Challet/blocs/damaging_model/damaging_model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DamagingDeviceModelBloc extends Bloc<DamagingDeviceModelEvent, DamagingDeviceModelState> {
  DamagingDeviceModelBloc() : super(DamagingDeviceModelStateInitial());

  DamagingDeviceModelState get initialState => DamagingDeviceModelStateInitial();

  @override
  void onTransition(Transition<DamagingDeviceModelEvent, DamagingDeviceModelState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<DamagingDeviceModelState> mapEventToState(DamagingDeviceModelEvent event) async* {
    if (event is CheckDamagingDeviceModelEvent) yield* _handleCheckDamagingDeviceModel(event);
  }

  Stream<DamagingDeviceModelState> _handleCheckDamagingDeviceModel(CheckDamagingDeviceModelEvent event) async* {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (DamagingModels.models.contains(androidInfo.brand)) {
        yield DamagingDeviceModelStateChecked(isImagePickerOk: false, isReturnToMapOk: false);
      } else {
        yield DamagingDeviceModelStateChecked(isImagePickerOk: true, isReturnToMapOk: true);
      }
    } else if (Platform.isIOS) {
      yield DamagingDeviceModelStateChecked(isImagePickerOk: true, isReturnToMapOk: true);
    }
  }
}

class DamagingModels {
  static const String REDMI = 'Redmi';
  static const List<String> models = [REDMI];
}

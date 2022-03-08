import 'package:equatable/equatable.dart';

abstract class ChaletIconEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetChaletIcon extends ChaletIconEvent {
  GetChaletIcon();
}

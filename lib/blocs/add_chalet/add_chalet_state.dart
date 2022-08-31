import 'package:Challet/models/index.dart';
import 'package:equatable/equatable.dart';

class AddChaletState extends Equatable {
  AddChaletState();

  @override
  List<Object> get props => [];
}

class AddChaletStateInitial extends AddChaletState {}

class AddChaletStateLoading extends AddChaletState {}

class AddChaletChaletAddedLoadingImages extends AddChaletState {}

class AddChaletStateCreated extends AddChaletState {
  final ChaletModel chalet;
  AddChaletStateCreated({required this.chalet});
  @override
  List<Object> get props => [chalet];
}

class AddChaletStateError extends AddChaletState {
  final String errorMessage;
  AddChaletStateError(this.errorMessage);
}

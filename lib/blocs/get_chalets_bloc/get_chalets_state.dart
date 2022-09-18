import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';

class GetChaletsState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetChaletsStateInitial extends GetChaletsState {}

class GetChaletsStateLoading extends GetChaletsState {}

class GetChaletsStateSorting extends GetChaletsState {}

class GetChaletsStateLoaded extends GetChaletsState {
  final List<ChaletModel> chaletList;
  final String sortingValue;

  GetChaletsStateLoaded({
    required this.chaletList,
    required this.sortingValue,
  });

  @override
  List<Object> get props => [chaletList];
}

class GetChaletsStateError extends GetChaletsState {
  final String errorMessage;
  GetChaletsStateError({required this.errorMessage});
}

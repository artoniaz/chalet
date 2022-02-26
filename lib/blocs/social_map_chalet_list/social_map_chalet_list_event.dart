import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ChaletListForSocialMapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetChaletListForSocialMap extends ChaletListForSocialMapEvent {
  final List<String> teamMembersIds;

  GetChaletListForSocialMap(
    this.teamMembersIds,
  );
}

class UpdateChaletListForSocialMap extends ChaletListForSocialMapEvent {
  final List<ChaletModel> chaletListForSocialMap;

  UpdateChaletListForSocialMap(
    this.chaletListForSocialMap,
  );

  @override
  List<Object> get props => [chaletListForSocialMap];
}

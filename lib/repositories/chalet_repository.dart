import 'package:chalet/models/index.dart';
import 'package:chalet/services/chalet_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ChaletRepository {
  final _chaletService = ChaletService();

  Stream<List<ChaletModel>> getChaletStream(BehaviorSubject<LatLng> subject) => _chaletService.getChaletStream(subject);

  Future<String?> createChalet(ChaletModel chalet) => _chaletService.createChalet(chalet);

  Stream<List<ChaletModel>> getChaletListAddedByUsers(List<String> teamMembersIds) =>
      _chaletService.getChaletListAddedByUsers(teamMembersIds);
}

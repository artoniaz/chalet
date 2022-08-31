import 'package:Challet/services/chalet_icon_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChaletIconRepository {
  final _chaletIconService = ChaletIconService();
  Future<BitmapDescriptor> getBitmapDescriptor() => _chaletIconService.getBitmapDescriptor();
}

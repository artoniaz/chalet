import 'package:chalet/models/index.dart';
import 'package:chalet/services/chalet_service.dart';

class ChaletRepository {
  final _chaletService = ChaletService();
  Future<String?> createChalet(ChaletModel chalet) => _chaletService.createChalet(chalet);
}

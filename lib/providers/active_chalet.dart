import 'package:Challet/models/index.dart';
import 'package:flutter/cupertino.dart';

class ActiveChalet extends ChangeNotifier {
  ChaletModel? _activeChalet;
  ChaletModel? get getActiveChalet => _activeChalet;

  void changeActiveChalet(ChaletModel chalet) {
    _activeChalet = chalet;
    notifyListeners();
  }
}

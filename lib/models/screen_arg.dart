import 'package:chalet/models/index.dart';

class ChaletDetailsArgs {
  final ChaletModel chalet;
  ChaletDetailsArgs({required this.chalet});
}

class ReportProblemArgs {
  final String chaletId;
  final String chaletName;
  ReportProblemArgs({
    required this.chaletId,
    required this.chaletName,
  });
}

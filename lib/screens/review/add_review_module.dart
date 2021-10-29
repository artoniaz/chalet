import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/screens/review/rating_dialogs/dialog_types.dart';
import 'package:chalet/screens/review/rating_dialogs/full_rating_dialog.dart';
import 'package:chalet/screens/review/rating_dialogs/quick_rating_dialog_confirm.dart';
import 'package:chalet/screens/review/rating_dialogs/not_allowed_dialog.dart';
import 'package:chalet/screens/review/rating_dialogs/quick_rating_dialog.dart';
import 'package:chalet/services/review_service.dart';
import 'package:chalet/widgets/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddReviewModule extends StatefulWidget {
  final String chaletId;
  const AddReviewModule({
    Key? key,
    required this.chaletId,
  }) : super(key: key);

  @override
  _AddReviewModuleState createState() => _AddReviewModuleState();
}

class _AddReviewModuleState extends State<AddReviewModule> {
  double _chaletRating = 0.0;
  TextEditingController _chaletDescController = TextEditingController();
  FocusNode _chaletDescFocusNode = FocusNode();

  String _currentReviewId = '';
  String? _currentRatingType;

  bool _validateQuickReview = false;

  Widget? _getDialog(void Function(void Function()) innerSetState, String userId, String userName) {
    if (_currentRatingType == DialogTypes.quickRatingDialog)
      return QuickRatingDialog(
          key: ValueKey(DialogTypes.quickRatingDialog),
          handleRatingUpdate: _handleRatingUpdate,
          chaletDescController: _chaletDescController,
          chaletDescFocusNode: _chaletDescFocusNode,
          validateQuickReview: _validateQuickReview,
          createReview: () async {
            if (_chaletRating > 0 && _chaletDescController.text.length > 0) {
              await _createReview(userId, userName);
              innerSetState(() => _currentRatingType = DialogTypes.fullRatingDialog);
            } else
              innerSetState(() => _validateQuickReview = true);
          });
    else if (_currentRatingType == DialogTypes.quickRatingDialogConfirm)
      return QuickRatingDialogConfirm(
        key: ValueKey(
          DialogTypes.quickRatingDialogConfirm,
        ),
        chaletRating: _chaletRating,
        goToFullReview: () => innerSetState(() => _currentRatingType = DialogTypes.fullRatingDialog),
      );
    else if (_currentRatingType == DialogTypes.fullRatingDialog)
      return FullRatingDialog(
        key: ValueKey(DialogTypes.fullRatingDialog),
        chaletId: widget.chaletId,
        reviewId: _currentReviewId,
        chaletRating: _chaletRating,
        handleCloseDialog: () {
          innerSetState(() => _currentRatingType = DialogTypes.notAllowedDialog);
          Navigator.of(context).pop();
        },
      );
    else
      return NotAllowedDialog(
        key: ValueKey(DialogTypes.notAllowedDialog),
        chaletRating: _chaletRating,
      );
  }

  void _handleRatingUpdate(double rating) {
    setState(() => _chaletRating = rating);
    if (_chaletDescController.text == '') _chaletDescFocusNode.requestFocus();
  }

  Future<String> _validateLastReviewForChalet(String userId) async {
    final reviews = await ReviewService().getLastUserReviewForChalet(widget.chaletId, userId);
    if (reviews.isNotEmpty) {
      ReviewModel rev = reviews.first;
      int daysSinceLastReview = calcDaysBetween(rev.created);
      if (daysSinceLastReview > 0)
        return DialogTypes.quickRatingDialog;
      else if (daysSinceLastReview <= 0 && !rev.hasUserAddedFullReview) {
        setState(() => _chaletRating = rev.rating);
        return DialogTypes.quickRatingDialogConfirm;
      } else
        setState(() => _chaletRating = rev.rating);
      return DialogTypes.notAllowedDialog;
    } else {
      return DialogTypes.quickRatingDialog;
    }
  }

  _initDialogModule(String userId, String userName) async {
    String dialogType = await _validateLastReviewForChalet(userId);
    setState(() => _currentRatingType = dialogType);
    _ratingPopUp(context, userId, userName);
  }

  Future<void> _createReview(String userId, String userName) async {
    try {
      String reviewId = await ReviewService().createQuickReview(ReviewModel(
        id: '',
        chaletId: widget.chaletId,
        userId: userId,
        userName: userName,
        rating: _chaletRating,
        description: _chaletDescController.text,
        created: Timestamp.now(),
        hasUserAddedFullReview: false,
      ));
      if (reviewId != '') {
        setState(() => _currentReviewId = reviewId);
      } else
        throw 'Błąd dodawania oceny';
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  void didUpdateWidget(covariant AddReviewModule oldWidget) {
    if (oldWidget.chaletId != widget.chaletId) {
      setState(() {
        _currentRatingType = null;
        _chaletDescController.clear();
        _validateQuickReview = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _chaletDescFocusNode.dispose();
    _chaletDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return CustomElevatedButton(label: 'Oceń', onPressed: () => _initDialogModule(user!.uid, ''));
  }

  Future<dynamic> _ratingPopUp(BuildContext context, String userId, String userName) async => showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, innerSetState) {
          return AnimatedSwitcher(
              transitionBuilder: (child, animation) => ScaleTransition(
                    child: child,
                    scale: animation,
                  ),
              child: _getDialog(innerSetState, userId, userName),
              duration: Duration(milliseconds: 400));
        });
      });
}

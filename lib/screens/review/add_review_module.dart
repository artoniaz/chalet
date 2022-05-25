import 'package:chalet/blocs/add_review/add_review_bloc.dart';
import 'package:chalet/blocs/add_review/add_review_event.dart';
import 'package:chalet/blocs/add_review/add_review_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/validate_quick_review/validate_quick_review_bloc.dart';
import 'package:chalet/blocs/validate_quick_review/validate_quick_review_event.dart';
import 'package:chalet/blocs/validate_quick_review/validate_quick_review_state.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/repositories/team_feed_info_repository.dart';
import 'package:chalet/screens/review/rating_dialogs/dialog_types.dart';
import 'package:chalet/screens/review/rating_dialogs/full_rating_dialog.dart';
import 'package:chalet/screens/review/rating_dialogs/not_allowed_dialog.dart';
import 'package:chalet/screens/review/rating_dialogs/quick_rating_dialog.dart';
import 'package:chalet/screens/review/rating_dialogs/quick_rating_dialog_confirm.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddReviewModule extends StatefulWidget {
  final ChaletModel chalet;
  const AddReviewModule({
    Key? key,
    required this.chalet,
  }) : super(key: key);

  @override
  _AddReviewModuleState createState() => _AddReviewModuleState();
}

class _AddReviewModuleState extends State<AddReviewModule> {
  late AddReviewBloc _addReviewBloc;
  late ValidateQuickReviewBloc _validateQuickReviewBloc;
  late UserModel? _user;
  TextEditingController _chaletDescController = TextEditingController();
  FocusNode _chaletDescFocusNode = FocusNode();
  bool _validateQuickReview = false;
  ScrollController _dialogController = ScrollController();
  double _chaletRating = 0.0;

  void _handleRatingUpdate(double rating) {
    setState(() => _chaletRating = rating);
    if (_chaletDescController.text == '') _chaletDescFocusNode.requestFocus();
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      _dialogController.jumpTo(_dialogController.position.maxScrollExtent);
    });
  }

  void _handleCreateQuickReview() {
    _validateQuickReviewBloc.add(ValidateQuickReview(
      _chaletRating,
      _chaletDescController.text,
      ReviewModel(
        id: '',
        chaletId: widget.chalet.id,
        userId: _user!.uid,
        userName: _user!.displayName ?? '',
        rating: _chaletRating,
        description: _chaletDescController.text,
        created: Timestamp.now(),
        hasUserAddedFullReview: false,
      ),
      FeedInfoModel(
        id: '',
        teamId: _user!.teamId ?? '',
        userId: _user!.uid,
        chaletId: widget.chalet.id,
        chaletName: widget.chalet.name,
        userName: _user!.displayName ?? '',
        role: FeedInfoRole.rating,
        chaletRating: _chaletRating,
        created: Timestamp.now(),
        congratsSenderList: [],
      ),
    ));
  }

  void _handleGoToFullReviewBtn() {
    _addReviewBloc.add(GoToFullReviewDialog());
  }

  @override
  void initState() {
    _addReviewBloc = BlocProvider.of<AddReviewBloc>(context, listen: false);
    _validateQuickReviewBloc = BlocProvider.of<ValidateQuickReviewBloc>(context, listen: false);
    _user = context.read<UserDataBloc>().state.props.first as UserModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddReviewBloc, AddReviewState>(
      bloc: _addReviewBloc,
      listener: (context, state) {
        if (state is AddReviewValidateRatingsLoading) {
          EasyLoading.show(maskType: EasyLoadingMaskType.clear);
        } else if (state is AddReviewStateQuickRating) {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (context) => QuickRatingDialog(
                    key: ValueKey(DialogTypes.quickRatingDialog),
                    addReviewBloc: _addReviewBloc,
                    handleRatingUpdate: _handleRatingUpdate,
                    chaletDescController: _chaletDescController,
                    chaletDescFocusNode: _chaletDescFocusNode,
                    validateQuickReview: _validateQuickReview,
                    scrollController: _dialogController,
                    createReview: _handleCreateQuickReview,
                  )).then((value) {
            _validateQuickReviewBloc.add(ResetQuickReview());
            _chaletDescController.text = '';
            _chaletRating = 0.0;
          });
        } else if (state is AddReviewStateFullRatingDialog) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) => FullRatingDialog(
                    key: ValueKey(DialogTypes.fullRatingDialog),
                    addReviewBloc: _addReviewBloc,
                    chaletId: widget.chalet.id,
                    reviewId: state.currentReviewId,
                    chaletRating: state.chaletRating,
                  ));
        } else if (state is AddReviewStateQuickRatingConfirm) {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (context) => QuickRatingDialogConfirm(
                    key: ValueKey(
                      DialogTypes.quickRatingDialogConfirm,
                    ),
                    chaletRating: state.chaletRating,
                    goToFullReview: _handleGoToFullReviewBtn,
                  ));
        } else if (state is AddReviewStateQuickRatingNotAllowed) {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (context) => NotAllowedDialog(
                    key: ValueKey(DialogTypes.notAllowedDialog),
                    chaletRating: state.chaletRating,
                  ));
        } else if (state is AddReviewStateClear) {
          Navigator.of(context).pop();
        } else if (state is AddReviewStateError) {
          EasyLoading.showError(state.errorMessage);
        }
      },
      builder: (context, state) => CustomElevatedButton(
          label: 'Zostaw balas',
          backgroundColor: Palette.goldLeaf,
          onPressed: state is AddReviewValidateRatingsLoading
              ? null
              : () {
                  _addReviewBloc.add(
                    GetLastUserReviewForChalet(chaletId: widget.chalet.id, userId: _user!.uid),
                  );
                }),
    );
  }
}

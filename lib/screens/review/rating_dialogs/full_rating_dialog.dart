import 'package:chalet/blocs/add_review/add_review_bloc.dart';
import 'package:chalet/blocs/add_review/add_review_event.dart';
import 'package:chalet/blocs/add_review/add_review_state.dart';
import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FullRatingDialog extends StatefulWidget {
  final String reviewId;
  final String chaletId;
  final double chaletRating;
  final AddReviewBloc addReviewBloc;
  const FullRatingDialog({
    Key? key,
    required this.chaletId,
    required this.reviewId,
    required this.chaletRating,
    required this.addReviewBloc,
  }) : super(key: key);

  @override
  _FullRatingDialogState createState() => _FullRatingDialogState();
}

class _FullRatingDialogState extends State<FullRatingDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ReviewDetailsModel _reviewDetails = ReviewDetailsModel(
    paper: 0.0,
    clean: 0.0,
    privacy: 0.0,
  );

  bool _isFormValidated = true;

  void _handleCleanRatingUpdate(double rating) => setState(() => _reviewDetails.clean = rating);
  void _handlePaperRatingUpdate(double rating) => setState(() => _reviewDetails.paper = rating);
  void _handlePrivacyRatingUpdate(double rating) => setState(() => _reviewDetails.privacy = rating);

  bool _validateForm() => _reviewDetails.paper > 0 && _reviewDetails.clean > 0 && _reviewDetails.privacy > 0;

  _addDetailsReviewToQuickReview() {
    if (_validateForm()) {
      widget.addReviewBloc.add(AddDetailsReviewToQuickReview(widget.chaletId, widget.reviewId, _reviewDetails));
    }
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 700)).then((value) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        controller: _scrollController,
        child: BlocListener<AddReviewBloc, AddReviewState>(
          listener: (context, state) {
            if (state is AddReviewStateClear) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Twoja ogólna ocena',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  CustomRatingBarIndicator(
                    rating: widget.chaletRating,
                    itemSize: 30.0,
                  ),
                  VerticalSizedBox16(),
                  Text(
                    'Oceń szczegóły szaletu',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  VerticalSizedBox16(),
                  RatingBarCol(
                    label: 'Papier',
                    handleRatingUpdate: _handlePaperRatingUpdate,
                  ),
                  VerticalSizedBox8(),
                  RatingBarCol(
                    label: 'Czystość',
                    handleRatingUpdate: _handleCleanRatingUpdate,
                  ),
                  VerticalSizedBox8(),
                  RatingBarCol(
                    label: 'Prywatność',
                    handleRatingUpdate: _handlePrivacyRatingUpdate,
                  ),
                  VerticalSizedBox8(),
                  if (!_isFormValidated)
                    Text(
                      'Uzupełnij wszystkie oceny',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red),
                    ),
                  VerticalSizedBox24(),
                  BlocBuilder<AddReviewBloc, AddReviewState>(
                      bloc: widget.addReviewBloc,
                      builder: (context, state) {
                        return ButtonsPopUpRow(
                          approveButtonLabel: 'Zapisz ocenę',
                          onPressedApproveButton:
                              state is AddReviewStateRequestLoading ? null : _addDetailsReviewToQuickReview,
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

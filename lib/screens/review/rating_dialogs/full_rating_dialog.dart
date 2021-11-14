import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/services/review_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FullRatingDialog extends StatefulWidget {
  final String reviewId;
  final String chaletId;
  final Function handleCloseDialog;
  final double chaletRating;
  const FullRatingDialog({
    Key? key,
    required this.chaletId,
    required this.reviewId,
    required this.handleCloseDialog,
    required this.chaletRating,
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
    describtionExtended: '',
  );

  bool _isFormValidated = true;

  void _handleCleanRatingUpdate(double rating) => setState(() => _reviewDetails.clean = rating);
  void _handlePaperRatingUpdate(double rating) => setState(() => _reviewDetails.paper = rating);
  void _handlePrivacyRatingUpdate(double rating) => setState(() => _reviewDetails.privacy = rating);
  void _handleDetailsExtendedUpdate(String desc) => setState(() => _reviewDetails.describtionExtended = desc);

  bool _validateForm() => _reviewDetails.paper > 0 && _reviewDetails.clean > 0 && _reviewDetails.privacy > 0;

  Future<void> _addDetailsReviewToQuickReview() async {
    try {
      if (_validateForm()) {
        await ReviewService().addDetailsReviewToQuickReview(widget.chaletId, widget.reviewId, _reviewDetails);
        widget.handleCloseDialog();
        EasyLoading.showSuccess('Dodano ocenę szaletu');
      } else {}
    } catch (e) {
      EasyLoading.showError(e.toString());
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
                TextField(
                    minLines: 2,
                    maxLines: 4,
                    onChanged: _handleDetailsExtendedUpdate,
                    focusNode: _focusNode,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Dokładny opis. Podziel się szczegółami!',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )),
                    )),
                if (!_isFormValidated)
                  Text(
                    'Uzupełnij wszystkie oceny',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red),
                  ),
                VerticalSizedBox24(),
                ButtonsPopUpRow(
                  approveButtonLabel: 'Zapisz ocenę',
                  onPressedApproveButton: _addDetailsReviewToQuickReview,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

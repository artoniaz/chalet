import 'package:chalet/blocs/add_review/add_review_bloc.dart';
import 'package:chalet/blocs/add_review/add_review_state.dart';
import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickRatingDialog extends StatelessWidget {
  final Function(double) handleRatingUpdate;
  final TextEditingController chaletDescController;
  final FocusNode chaletDescFocusNode;
  final Function createReview;
  final bool validateQuickReview;
  final ScrollController scrollController;
  final AddReviewBloc addReviewBloc;
  const QuickRatingDialog({
    Key? key,
    required this.handleRatingUpdate,
    required this.chaletDescController,
    required this.chaletDescFocusNode,
    required this.createReview,
    required this.validateQuickReview,
    required this.scrollController,
    required this.addReviewBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: GestureDetector(
        onTap: () => dissmissCurrentFocus(context),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Twoja ocena szaletu',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  VerticalSizedBox8(),
                  Text(
                    'Oceń Twoje ogóle wrażenie z pobytu w tym szalecie',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  VerticalSizedBox16(),
                  RatingBarItem(handleRatingUpdate: handleRatingUpdate),
                  VerticalSizedBox8(),
                  TextField(
                      minLines: 2,
                      maxLines: 4,
                      controller: chaletDescController,
                      focusNode: chaletDescFocusNode,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Opis',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        )),
                      )),
                  if (validateQuickReview)
                    Text(
                      'Uzupełnij ocenę i opis',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red),
                    ),
                  VerticalSizedBox16(),
                  BlocBuilder<AddReviewBloc, AddReviewState>(
                      bloc: addReviewBloc,
                      builder: (context, state) {
                        return ButtonsPopUpRow(
                          approveButtonLabel: 'Zapisz ocenę',
                          onPressedApproveButton: state is AddReviewStateRequestLoading ? null : createReview,
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

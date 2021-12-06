import 'package:chalet/blocs/review/review_bloc.dart';
import 'package:chalet/blocs/review/review_event.dart';
import 'package:chalet/blocs/review/review_state.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/review_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/index.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChaletReviewList extends StatefulWidget {
  final String chaletId;
  final Function(GlobalKey) scrollReviewList;
  const ChaletReviewList({
    Key? key,
    required this.chaletId,
    required this.scrollReviewList,
  }) : super(key: key);

  @override
  _ChaletReviewListState createState() => _ChaletReviewListState();
}

class _ChaletReviewListState extends State<ChaletReviewList> {
  late ReviewBloc _reviewBloc;
  bool _displayShowMoreReviewsButton = false;
  bool _isLoading = true;
  bool _isLoadingMoreReviews = false;
  List<ReviewModel> _reviewList = [];
  GlobalKey _itemKey = GlobalKey();

  void _handleListener(BuildContext context, ReviewState state) {
    if (state is ReviewStateLoaded) {
      setState(() {
        _reviewList = state.reviewList;
        _displayShowMoreReviewsButton = state.displayShowMoreReviewsButton;
        _isLoading = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.scrollReviewList(_itemKey);
      });
    }
    if (state is MoreReviewStateLoaded) {
      setState(() {
        _reviewList += state.reviewList;
        _displayShowMoreReviewsButton = state.displayShowMoreReviewsButton;
        _isLoadingMoreReviews = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.scrollReviewList(_itemKey);
      });
    }
    if (state is MoreReviewStateLoading)
      setState(() {
        _isLoadingMoreReviews = true;
      });
  }

  @override
  void initState() {
    _reviewBloc = BlocProvider.of<ReviewBloc>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _reviewBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Oceny',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        BlocConsumer<ReviewBloc, ReviewState>(
            bloc: _reviewBloc,
            listener: _handleListener,
            builder: (context, state) {
              if (state is ReviewStateInitial) {
                return CustomElevatedButton(
                  label: 'Pokaż oceny',
                  onPressed: () => _reviewBloc.add(GetReviewsEvent(widget.chaletId)),
                  backgroundColor: Palette.goldLeaf,
                );
              }
              if (state is ReviewStateLoading) {
                return Loading();
              }
              if (state is ReviewStateLoadedEmpty) {
                return Text(
                  'Brak ocen',
                  style: Theme.of(context).textTheme.bodyText1,
                );
              }
              if (state is ReviewStateError)
                return ErrorMessageContainer(errorMessage: state.error);
              else
                return Column(
                  key: _itemKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._reviewList
                        .asMap()
                        .map((i, el) =>
                            MapEntry(i, ReviewContainer(review: el, isLastReviewOnList: i == _reviewList.length - 1)))
                        .values
                        .toList(),
                    if (_displayShowMoreReviewsButton && !_isLoadingMoreReviews)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSizedBox16(),
                          CustomElevatedButton(
                            label: 'Pokaż więcej ocen',
                            onPressed: () => _reviewBloc
                                .add(GetMoreReviewsForChalet(widget.chaletId, _reviewList[_reviewList.length - 1])),
                          ),
                        ],
                      ),
                    if (_isLoadingMoreReviews)
                      Loading(
                        spinnerColor: Palette.darkBlue,
                        backgroundColor: Colors.transparent,
                      ),
                  ],
                );
            }),
      ],
    );
  }
}

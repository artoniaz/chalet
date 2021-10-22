import 'package:chalet/models/review_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/review_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChaletReviewList extends StatefulWidget {
  final String chaletId;
  const ChaletReviewList({
    Key? key,
    required this.chaletId,
  }) : super(key: key);

  @override
  _ChaletReviewListState createState() => _ChaletReviewListState();
}

class _ChaletReviewListState extends State<ChaletReviewList> {
  List<ReviewModel> _reviewList = [];
  bool isLoading = true;
  bool isError = false;
  bool _displayShowMoreReviewsButton = false;

  Future<void> getMoreReviewsForChalet() async {
    try {
      List<ReviewModel> reviews =
          await ReviewService().getMoreReviewsForChalet(widget.chaletId, _reviewList[_reviewList.length - 1]);
      setState(() {
        _reviewList += reviews;
        _displayShowMoreReviewsButton = reviews.length == 5;
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<void> getInitData() async {
    try {
      List<ReviewModel> reviews = await ReviewService().getReviewsForChalet(widget.chaletId);
      setState(() {
        _reviewList = reviews;
        _displayShowMoreReviewsButton = reviews.length == 5;
        isLoading = false;
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  void didUpdateWidget(covariant ChaletReviewList oldWidget) {
    if (oldWidget.chaletId != widget.chaletId) {
      setState(() => isLoading = true);
      getInitData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isError
        ? Spacer()
        : isLoading
            ? Row(
                children: [
                  Loading(
                    spinnerColor: Palette.darkBlue,
                    backgroundColor: Colors.transparent,
                  ),
                  Spacer(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _reviewList.isEmpty
                    ? [Text('Brak ocen')]
                    : [
                        ..._reviewList.map((el) => ReviewContainer(review: el)),
                        if (_displayShowMoreReviewsButton)
                          CustomElevatedButton(
                            label: 'Pokaż więcej ocen',
                            onPressed: getMoreReviewsForChalet,
                          )
                      ],
              );
  }
}

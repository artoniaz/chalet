import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/screens/chalet/chalet_conveniences_types.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  final ReviewModel review;
  const ReviewContainer({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSizedBox16(),
        Text(
          review.userName != '' ? review.userName : 'Anonimowy użytkownik',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            CustomRatingBarIndicator(
              rating: review.rating,
            ),
            HorizontalSizedBox8(),
            Text(timestampToDate(review.created)),
          ],
        ),
        VerticalSizedBox8(),
        Text(
          review.description,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        if (review.hasUserAddedFullReview)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ChaletConvenience(
                    convenienceType: ConveniencesTypes.paper,
                    convenienceScore: review.reviewDetails!.paper,
                    size: 30.0,
                    isMainDisplay: false,
                  ),
                  HorizontalSizedBox16(),
                  ChaletConvenience(
                    convenienceType: ConveniencesTypes.clean,
                    convenienceScore: review.reviewDetails!.clean,
                    size: 30.0,
                    isMainDisplay: false,
                  ),
                  HorizontalSizedBox16(),
                  ChaletConvenience(
                    convenienceType: ConveniencesTypes.privacy,
                    convenienceScore: review.reviewDetails!.privacy,
                    size: 30.0,
                    isMainDisplay: false,
                  ),
                ],
              ),
              Text(
                review.reviewDetails!.describtionExtended,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        Divider(),
      ],
    );
  }
}

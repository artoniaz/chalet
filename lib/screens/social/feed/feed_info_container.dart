import 'package:chalet/config/functions/feed_display_info_helpers.dart';
import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/horizontal_sized_boxes.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedInfoContainer extends StatelessWidget {
  final FeedInfoModel feedInfo;
  const FeedInfoContainer({
    Key? key,
    required this.feedInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimentions.medium),
      margin: EdgeInsets.only(bottom: Dimentions.big),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.lightGrey),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        width: 20.0,
                        height: 20.0,
                        image: AssetImage('assets/poo/poo_happy.png'),
                      ),
                      HorizontalSizedBox16(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feedInfo.userName,
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            getTimeagoFromDateTime(feedInfo.created),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      )
                    ],
                  ),
                  VerticalSizedBox16(),
                  Text(
                    getFeedDisplayInfoModel(feedInfo.role).feedDescription,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  VerticalSizedBox16(),
                  CustomElevatedButton(
                    label: 'Pogratuluj',
                    backgroundColor: Palette.goldLeaf,
                    onPressed: () {},
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: Image(
              width: 45.0,
              height: 45.0,
              image: AssetImage('assets/poo/poo_happy.png'),
            ),
          )
        ],
      ),
    );
  }
}

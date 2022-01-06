import 'package:chalet/models/feed_info_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class FeedInfoList extends StatelessWidget {
  final List<FeedInfoModel> feedInfoList;
  const FeedInfoList({
    Key? key,
    required this.feedInfoList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimentions.big),
            child: TextDivider(text: 'Nowe'),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimentions.medium),
            child: Column(
              children: feedInfoList.map((el) => FeedInfoContainer(feedInfo: el)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

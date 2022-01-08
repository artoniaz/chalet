import 'package:chalet/screens/index.dart';
import 'package:flutter/material.dart';

class SocialMainPage extends StatelessWidget {
  const SocialMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TeamList(),
              FeedInfoList(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chalet/screens/index.dart';
import 'package:flutter/material.dart';

class SocialMainPage extends StatefulWidget {
  const SocialMainPage({Key? key}) : super(key: key);

  @override
  State<SocialMainPage> createState() => _SocialMainPageState();
}

class _SocialMainPageState extends State<SocialMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 1, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            // child: Stack(
            //   alignment: Alignment.topCenter,
            //   children: [
            //     TabBarView(
            //       // physics: NeverScrollableScrollPhysics(),
            //       controller: _tabController,

            //       children: [
            //         Column(
            //           children: [
            //             TeamList(),
            //             FeedInfoList(),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            ),
      ),
    );
  }
}

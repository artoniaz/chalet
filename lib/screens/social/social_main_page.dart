import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class SocialMainPage extends StatefulWidget {
  const SocialMainPage({Key? key}) : super(key: key);

  @override
  State<SocialMainPage> createState() => _SocialMainPageState();
}

class _SocialMainPageState extends State<SocialMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                TeamFeedPage(),
                Center(child: Text('social mapa')),
                Center(child: Text('statystyki')),
              ],
            ),
            Positioned(
              top: Dimentions.small,
              child: SafeArea(
                child: FlutterToggleTab(
                  width: 100.0 - Dimentions.small,
                  borderRadius: 30.0,
                  height: 35.0,
                  selectedIndex: _tabController.index,
                  selectedTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(color: Palette.ivoryBlack, fontSize: 12, fontWeight: FontWeight.w500),
                  selectedBackgroundColors: [Palette.chaletBlue],
                  labels: [
                    "Mój team",
                    "Mapa",
                    "Statystyki",
                  ],
                  icons: [
                    Icons.people,
                    Icons.map,
                    Icons.query_stats,
                  ],
                  selectedLabelIndex: (index) {
                    setState(() {
                      _tabController.animateTo(index);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamFeedPage extends StatefulWidget {
  const TeamFeedPage({Key? key}) : super(key: key);

  @override
  _TeamFeedPageState createState() => _TeamFeedPageState();
}

class _TeamFeedPageState extends State<TeamFeedPage> with AutomaticKeepAliveClientMixin<TeamFeedPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TeamList(),
          FeedInfoList(),
        ],
      ),
    );
  }
}

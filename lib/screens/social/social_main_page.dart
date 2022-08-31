import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/team/team_event.dart';
import 'package:Challet/blocs/team/team_state.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';

class SocialMainPage extends StatefulWidget {
  const SocialMainPage({Key? key}) : super(key: key);

  @override
  State<SocialMainPage> createState() => _SocialMainPageState();
}

class _SocialMainPageState extends State<SocialMainPage> with SingleTickerProviderStateMixin {
  late TeamBloc _teamBloc;
  late TabController _tabController;
  late UserModel _user;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _teamBloc = Provider.of<TeamBloc>(context, listen: false);
    _teamBloc.add(GetTeamEvent(_user.teamId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
        bloc: _teamBloc,
        builder: (context, teamState) {
          if (teamState is TeamStateLoading) return Loading();
          if (teamState is TeamStateTeamLoaded)
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          TeamFeedPage(),
                          SocialMap(),
                          TeamStats(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: Dimentions.small,
                      child: SafeArea(
                        child: FlutterToggleTab(
                          width: 100.0 - Dimentions.toggleTabHorizontalPadding,
                          borderRadius: 30.0,
                          height: 35.0,
                          selectedIndex: _tabController.index,
                          selectedTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          unSelectedTextStyle:
                              TextStyle(color: Palette.ivoryBlack, fontSize: 12, fontWeight: FontWeight.w500),
                          selectedBackgroundColors: [Palette.chaletBlue],
                          labels: [
                            "Mój klan",
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
          if (teamState is TeamStateError)
            return Container(
              child: Center(
                child: Text(teamState.errorMessage),
              ),
            );
          else
            return Loading();
        });
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

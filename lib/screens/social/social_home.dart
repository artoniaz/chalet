import 'package:chalet/blocs/team_feed/team_feed_bloc.dart';
import 'package:chalet/blocs/team_feed/team_feed_event.dart';
import 'package:chalet/blocs/team_feed/team_feed_state.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SocialHome extends StatefulWidget {
  const SocialHome({Key? key}) : super(key: key);

  @override
  _SocialHomeState createState() => _SocialHomeState();
}

class _SocialHomeState extends State<SocialHome> {
  late TeamFeedInfoBloc _teamFeedInfoBloc;

  @override
  void initState() {
    _teamFeedInfoBloc = Provider.of<TeamFeedInfoBloc>(context, listen: false);
    _teamFeedInfoBloc.add(GetTeamFeedInfos('TEST_TEAM_ID'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeamFeedInfoBloc, TeamFeedInfoState>(
          bloc: _teamFeedInfoBloc,
          builder: (context, state) {
            if (state is TeamFeedInfoStateLoading) {
              return Loading();
            } else if (state is TeamFeedInfoStateLoaded) {
              return SingleChildScrollView(
                child: FeedInfoList(feedInfoList: state.feedInfoList),
              );
            } else if (state is TeamFeedInfoStateError) {
              return Center(child: Text(state.errorMessage));
            } else
              return Container();
          }),
    );
  }
}

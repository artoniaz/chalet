import 'package:chalet/blocs/team_feed/team_feed_bloc.dart';
import 'package:chalet/blocs/team_feed/team_feed_event.dart';
import 'package:chalet/blocs/team_feed/team_feed_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
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
  late UserDataBloc _userDataBloc;

  @override
  void initState() {
    _teamFeedInfoBloc = Provider.of<TeamFeedInfoBloc>(context, listen: false);
    _teamFeedInfoBloc.add(GetTeamFeedInfos('TEST_TEAM_ID'));
    _userDataBloc = Provider.of<UserDataBloc>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserDataBloc, UserDataState>(
          bloc: _userDataBloc,
          builder: (context, userDataState) {
            return BlocBuilder<TeamFeedInfoBloc, TeamFeedInfoState>(
                bloc: _teamFeedInfoBloc,
                builder: (context, teamFeedState) {
                  if (teamFeedState is TeamFeedInfoStateLoading) {
                    return Loading();
                  } else if (teamFeedState is TeamFeedInfoStateLoaded && userDataState is UserDataStateLoaded) {
                    return SingleChildScrollView(
                      child: FeedInfoList(feedInfoList: teamFeedState.feedInfoList),
                    );
                  } else if (teamFeedState is TeamFeedInfoStateError) {
                    return Center(child: Text(teamFeedState.errorMessage));
                  } else
                    return Container();
                });
          }),
    );
  }
}

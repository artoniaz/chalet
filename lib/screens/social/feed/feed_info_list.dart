import 'package:chalet/blocs/team_feed/team_feed_bloc.dart';
import 'package:chalet/blocs/team_feed/team_feed_event.dart';
import 'package:chalet/blocs/team_feed/team_feed_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FeedInfoList extends StatefulWidget {
  const FeedInfoList({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedInfoList> createState() => _FeedInfoListState();
}

class _FeedInfoListState extends State<FeedInfoList> {
  late TeamFeedInfoBloc _teamFeedInfoBloc;

  @override
  void initState() {
    UserModel _user = Provider.of<UserDataBloc>(context, listen: false).state.props.first as UserModel;
    _teamFeedInfoBloc = Provider.of<TeamFeedInfoBloc>(context, listen: false);
    _teamFeedInfoBloc.add(GetTeamFeedInfos(_user.teamId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamFeedInfoBloc, TeamFeedInfoState>(
        bloc: _teamFeedInfoBloc,
        builder: (context, teamFeedState) {
          if (teamFeedState is TeamFeedInfoStateLoading) {
            return Loading();
          } else if (teamFeedState is TeamFeedInfoStateLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (teamFeedState.feedInfoList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimentions.big),
                      child: TextDivider(text: 'Nowe'),
                    ),
                  if (teamFeedState.feedInfoList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimentions.big),
                      child: TextDivider(text: 'Brak aktywności członków klanu'),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(Dimentions.medium),
                    child: Column(
                      children: teamFeedState.feedInfoList.map((el) => FeedInfoContainer(feedInfo: el)).toList(),
                    ),
                  ),
                  if (teamFeedState.feedInfoList.length >= 20)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimentions.big),
                      child: TextDivider(text: 'Widzisz 20 najnowszych aktywności człownków'),
                    ),
                ],
              ),
            );
          } else if (teamFeedState is TeamFeedInfoStateError) {
            return Center(child: Text(teamFeedState.errorMessage));
          } else
            return Container();
        });
  }
}

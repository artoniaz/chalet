import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/screens/social/team_stats/team_name_container.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeamStats extends StatefulWidget {
  const TeamStats({Key? key}) : super(key: key);

  @override
  _TeamStatsState createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  late TeamMembersBloc _teamMembersBloc;
  late TeamBloc _teamBloc;
  late UserModel _user;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(List<String> teamMembersIds, UserModel user) async {
    _teamMembersBloc.add(GetTeamMembers(teamMembersIds, user));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _teamBloc = Provider.of<TeamBloc>(context, listen: false);
    _teamMembersBloc = Provider.of<TeamMembersBloc>(context, listen: false);
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
              body: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Dimentions.medium,
                  horizontal: Dimentions.horizontalPadding,
                ),
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(teamState.team.membersIds!, _user),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: TeamNameContainer(
                          teamName: teamState.team.name,
                        ),
                      ),
                      StatsGrid(
                        chaletReviewsNumber: teamState.team.chaletReviewsNumber ?? 0,
                        chaletAddedNumber: teamState.team.chaletAddedNumber ?? 0,
                        userCreatedTimestamp: Timestamp.now(),
                      ),
                      SliverToBoxAdapter(
                        child: Divider(),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(_teamMembersBloc.teamMemberList
                            .map((el) => TeamStatsMemberContainer(
                                  teamMember: el,
                                ))
                            .toList()),
                      ),
                    ],
                  ),
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
            return Container();
        });
  }
}

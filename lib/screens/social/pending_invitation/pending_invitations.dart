import 'package:Challet/blocs/pending_invitations_teams/pending_invitations_teams_bloc.dart';
import 'package:Challet/blocs/pending_invitations_teams/pending_invitations_teams_event.dart';
import 'package:Challet/blocs/pending_invitations_teams/pending_invitations_teams_state.dart';
import 'package:Challet/blocs/react_to_pending_invitation/react_to_pending_invitation_bloc.dart';
import 'package:Challet/blocs/team_feed/team_feed_bloc.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/repositories/team_repository.dart';
import 'package:Challet/repositories/user_data_repository.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/widgets/custom_appBars.dart';
import 'package:Challet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PendingInvitations extends StatefulWidget {
  const PendingInvitations({Key? key}) : super(key: key);

  @override
  _PendingInvitationsState createState() => _PendingInvitationsState();
}

class _PendingInvitationsState extends State<PendingInvitations> {
  late UserModel _user;
  late PendingInvitationsTeamsBloc _pendingInvitationsTeamsBloc;

  @override
  void initState() {
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _pendingInvitationsTeamsBloc = Provider.of<PendingInvitationsTeamsBloc>(context, listen: false);
    _pendingInvitationsTeamsBloc.add(GetPendingInvitationsTeams(_user.pendingInvitationsIds ?? []));
    super.initState();
  }

  @override
  void dispose() {
    _pendingInvitationsTeamsBloc.add(ResetPendingInvitationsTeam());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.customAppBarChaletBlue(context, 'Aktywne zaproszenia'),
      body: BlocBuilder<PendingInvitationsTeamsBloc, PendingInvitationsTeamsState>(
          bloc: _pendingInvitationsTeamsBloc,
          builder: (context, state) {
            if (state is PendingInvitationsTeamsStateLoading) {
              return Loading();
            }
            if (state is PendingInvitationsTeamsStateLoaded) {
              return Padding(
                padding: const EdgeInsets.all(Dimentions.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.pendingInvitationsTeamList
                      .asMap()
                      .map(
                        (i, team) => MapEntry(
                          i,
                          BlocProvider(
                            create: (context) => ReactToPendingInvitationBloc(
                              teamRepository: TeamRepository(),
                              userDataRepository: UserDataRepository(),
                              teamFeedInfoBloc: BlocProvider.of<TeamFeedInfoBloc>(context, listen: false),
                            ),
                            child: PendingTeamInvitationContainer(
                                team: team,
                                otherTeamId: state.pendingInvitationsTeamList.length > 1
                                    ? i == 0
                                        ? state.pendingInvitationsTeamList[1].id
                                        : state.pendingInvitationsTeamList[0].id
                                    : null),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              );
            }
            if (state is PendingInvitationsTeamsStateError) {
              return Container(
                child: Center(
                  child: Text(state.errorMessage),
                ),
              );
            } else
              return Container();
          }),
    );
  }
}

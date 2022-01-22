import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_bloc.dart';
import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_event.dart';
import 'package:chalet/blocs/pending_invitations_teams/pending_invitations_teams_state.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:nil/nil.dart';

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
    _pendingInvitationsTeamsBloc.add(GetPendingInvitationsTeamMembers(_user.pendingInvitationsIds ?? []));
    super.initState();
  }

  @override
  void dispose() {
    _pendingInvitationsTeamsBloc.add(ResetPendingInvitationsTeamMembers());
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
              return SafeArea(
                child: Column(
                  children: state.pendingInvitationsTeamsMemberList
                      .map(
                        (teamMemberList) => BlocProvider(
                          create: (context) => ReactToPendingInvitationBloc(
                            teamRepository: TeamRepository(),
                            userDataRepository: UserDataRepository(),
                          ),
                          child: PendingTeamInvitationContainer(
                            teamMemberList: teamMemberList,
                          ),
                        ),
                      )
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

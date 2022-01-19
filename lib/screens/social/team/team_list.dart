import 'package:chalet/blocs/pending_members/pending_members_bloc.dart';
import 'package:chalet/blocs/pending_members/pending_members_event.dart';
import 'package:chalet/blocs/pending_members/pending_members_state.dart';
import 'package:chalet/blocs/team_members/team_members_bloc.dart';
import 'package:chalet/blocs/team_members/team_members_event.dart';
import 'package:chalet/blocs/team_members/team_members_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/screens/social/team/pending_members_container.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/horizontal_sized_boxes.dart';
import 'package:chalet/widgets/loading.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  late TeamMembersBloc _teamMembersBloc;
  late UserModel _user;
  final double _circleAvatarRadius = 30.0;

  @override
  void initState() {
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _teamMembersBloc = Provider.of<TeamMembersBloc>(context, listen: false);
    _teamMembersBloc.add(GetTeamMembers(_user.teamId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamMembersBloc, TeamMembersState>(
        bloc: _teamMembersBloc,
        builder: (context, teamMembersState) {
          if (teamMembersState is TeamMembersStateLoading) return Loading();
          if (teamMembersState is TeamMembersStateLoaded) {
            return Padding(
              padding: const EdgeInsets.all(Dimentions.medium),
              child: Column(
                children: [
                  Text(
                    'Brązowi rycerze klanu ${_user.teamName}',
                    style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  VerticalSizedBox16(),
                  Container(
                    height: 92,
                    child: ListView(
                      dragStartBehavior: DragStartBehavior.down,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...teamMembersState.teamMemberList.map((el) => TeamMemberContainer(
                              teamMember: el,
                              circleAvatarRadius: _circleAvatarRadius,
                            )),
                        PendingMembersContainer(
                          circleAvatarRadius: _circleAvatarRadius,
                        ),
                        if (teamMembersState.teamMemberList.length < 10 &&
                            teamMembersState.teamMemberList.firstWhere((el) => el.id == _user.uid).isAdmin)
                          AddMemberIcon(
                            circleAvatarRadius: _circleAvatarRadius,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (teamMembersState is TeamMembersStateError)
            return Container(
              child: Text(teamMembersState.errorMessage),
            );
          else
            return Container();
        });
  }
}

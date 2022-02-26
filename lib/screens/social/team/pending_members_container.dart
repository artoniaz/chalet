import 'package:chalet/blocs/pending_members/pending_members_bloc.dart';
import 'package:chalet/blocs/pending_members/pending_members_event.dart';
import 'package:chalet/blocs/pending_members/pending_members_state.dart';
import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PendingMembersContainer extends StatefulWidget {
  final double circleAvatarRadius;

  const PendingMembersContainer({
    Key? key,
    required this.circleAvatarRadius,
  }) : super(key: key);

  @override
  _PendingMembersContainerState createState() => _PendingMembersContainerState();
}

class _PendingMembersContainerState extends State<PendingMembersContainer> {
  late PendingTeamMembersBloc _pendingTeamMembersBloc;
  late TeamBloc _teamBloc;

  @override
  void initState() {
    _pendingTeamMembersBloc = Provider.of<PendingTeamMembersBloc>(context, listen: false);
    _teamBloc = Provider.of<TeamBloc>(context, listen: false);
    _pendingTeamMembersBloc.add(GetPendingTeamMembers(_teamBloc.team));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingTeamMembersBloc, PendingTeamMembersState>(
        bloc: _pendingTeamMembersBloc,
        builder: (context, pendingTeamMembersState) {
          return pendingTeamMembersState is PendingTeamMemberListLoaded &&
                  pendingTeamMembersState.pendingTeamMemberList.isEmpty
              ? Container()
              : Container(
                  width: (widget.circleAvatarRadius + 5.0) * 2,
                  margin: EdgeInsets.only(right: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<PendingTeamMembersBloc, PendingTeamMembersState>(
                          bloc: _pendingTeamMembersBloc,
                          builder: (context, pendingTeamMembersState) {
                            if (pendingTeamMembersState is PendingTeamMembersStateLoading) {
                              return Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Palette.chaletBlue,
                                  ),
                                  VerticalSizedBox8(),
                                  Text(
                                    '',
                                  ),
                                ],
                              );
                            }
                            if (pendingTeamMembersState is PendingTeamMemberListLoaded) {
                              if (pendingTeamMembersState.pendingTeamMemberList.isNotEmpty)
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Palette.chaletBlue,
                                      child: IconButton(
                                        icon: Icon(Icons.help_outline_rounded),
                                        iconSize: widget.circleAvatarRadius + 20.0,
                                        color: Palette.white,
                                        onPressed: () => showCustomModalBottomSheet(
                                          context,
                                          (context) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: Dimentions.medium,
                                            ),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                              Text(
                                                'Zaproszenia oczekujące na akceptację',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              ...pendingTeamMembersState.pendingTeamMemberList.map((el) => ListTile(
                                                    leading: UserAvatar(
                                                      avatarId: el.avatarId!,
                                                      radius: 15,
                                                      backgroundColor: Palette.white,
                                                    ),
                                                    title: Text(el.displayName ?? ''),
                                                  ))
                                            ]),
                                          ),
                                        ),
                                      ),
                                      radius: widget.circleAvatarRadius + 5.0,
                                    ),
                                    VerticalSizedBox8(),
                                    Text(
                                      'oczekujące',
                                    ),
                                  ],
                                );
                              else
                                return Container();
                            } else
                              return Container();
                          }),
                    ],
                  ),
                );
        });
  }
}

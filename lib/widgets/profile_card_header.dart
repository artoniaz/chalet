import 'package:Challet/blocs/avatar_selection/avatar_selection_bloc.dart';
import 'package:Challet/blocs/avatar_selection/avatar_selection_event.dart';
import 'package:Challet/blocs/avatar_selection/avatar_selection_state.dart';
import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/team/team_state.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/screens/avatars/avatar_selection_container.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ProfileCardHeader extends StatefulWidget {
  final UserModel user;
  final bool isEditable;
  const ProfileCardHeader({
    Key? key,
    required this.user,
    this.isEditable = true,
  }) : super(key: key);

  @override
  State<ProfileCardHeader> createState() => _ProfileCardHeaderState();
}

class _ProfileCardHeaderState extends State<ProfileCardHeader> {
  late AvatarSelectionBloc _avatarSelectionBloc;
  late String _avatarId;
  bool _isOpen = false;

  void _onTapAvatar(String choosenAvatarId) {
    if (_avatarId != choosenAvatarId) {
      setState(() => _avatarId = choosenAvatarId);
      _avatarSelectionBloc.add(UpdateUserAvatarId(widget.user.uid, choosenAvatarId));
    }
  }

  @override
  void initState() {
    _avatarId = widget.user.avatarId ?? '';
    _avatarSelectionBloc = Provider.of<AvatarSelectionBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExpansionPanelList(
          elevation: 0.0,
          expandedHeaderPadding: EdgeInsets.zero,
          children: [
            ExpansionPanel(
              isExpanded: _isOpen,
              headerBuilder: (context, isOpen) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding, vertical: Dimentions.medium),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.displayName ?? '',
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            VerticalSizedBox8(),
                            Text(
                              widget.user.email,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Palette.grey,
                                  ),
                            ),
                            VerticalSizedBox8(),
                            if (widget.user.teamId != null && widget.user.teamId != '')
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Palette.chaletBlue,
                                  ),
                                  HorizontalSizedBox8(),
                                  BlocBuilder<TeamBloc, TeamState>(
                                      bloc: Provider.of<TeamBloc>(context, listen: false),
                                      builder: (context, teamState) {
                                        if (teamState is TeamStateTeamLoaded) {
                                          return Text(
                                            teamState.team.name,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                  color: Palette.chaletBlue,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          );
                                        } else
                                          return CircularProgressIndicator();
                                      }),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                );
              },
              body: Container(
                padding: EdgeInsets.only(
                  left: Dimentions.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: Dimentions.horizontalPadding,
                      ),
                      child: Divider(),
                    ),
                    Text(
                      'Edytuj awatar',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    BlocConsumer<AvatarSelectionBloc, AvatarSelectionState>(
                      listener: (context, avatarSelectionState) {
                        if (avatarSelectionState is AvatarSelectionStateLoading) {
                          EasyLoading.show(maskType: EasyLoadingMaskType.black, status: '');
                        } else if (avatarSelectionState is AvatarSelectionStateUpdated) {
                          EasyLoading.showSuccess('Zaktualizowano awatar');
                        } else if (avatarSelectionState is AvatarSelectionStateError) {
                          EasyLoading.showSuccess(avatarSelectionState.errorMessage);
                        }
                      },
                      builder: (context, avatarSelectionState) {
                        return AvatarSelectionContainer(
                          currentAvatarId: _avatarId,
                          onTapAvatar: avatarSelectionState is AvatarSelectionStateLoading ? (val) {} : _onTapAvatar,
                        );
                      },
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
        Positioned(
          right: Dimentions.horizontalPadding,
          child: Stack(
            children: [
              GestureDetector(
                child: UserAvatar(
                  avatarId: widget.user.avatarId!,
                  radius: 40,
                ),
                onTap: () => setState(() => _isOpen = !_isOpen),
              ),
              if (widget.isEditable)
                CustomTopRightPositionedWidget(
                  child: CustomRoundedIconButton(
                    iconData: Icons.edit,
                    iconSize: 20.0,
                    onPressed: () => setState(() => _isOpen = !_isOpen),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}

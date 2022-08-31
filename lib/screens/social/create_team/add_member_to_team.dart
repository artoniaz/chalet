import 'package:Challet/blocs/pending_members/pending_members_bloc.dart';
import 'package:Challet/blocs/pending_members/pending_members_event.dart';
import 'package:Challet/blocs/pending_members/pending_members_state.dart';
import 'package:Challet/blocs/team/team_bloc.dart';
import 'package:Challet/blocs/team_member/team_member_bloc.dart';
import 'package:Challet/blocs/team_member/team_member_event.dart';
import 'package:Challet/blocs/team_member/team_member_state.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/config/functions/dissmis_focus.dart';
import 'package:Challet/models/team_model.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddMemberToTeam extends StatefulWidget {
  const AddMemberToTeam({
    Key? key,
  }) : super(key: key);

  @override
  _AddMemberToTeamState createState() => _AddMemberToTeamState();
}

class _AddMemberToTeamState extends State<AddMemberToTeam> {
  late TeamMemberBloc _teamMemberBloc;
  late PendingTeamMembersBloc _pendingTeamMembersBloc;
  late TeamModel _team;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _teamNameController = TextEditingController();
  late UserModel _user;
  late List<UserModel> _pendingTeamMembers;

  bool _handleCanBeInvitedValidation(TeamMemberState teamMemberState, PendingTeamMembersState pendingTeamMembersState) {
    if (teamMemberState is TeamMemberStateLoading) return false;
    if (teamMemberState is TeamMemberStateUserFound &&
        _pendingTeamMembers.indexWhere((el) => el.uid == teamMemberState.userLookedFor.uid) > -1) return false;
    if (pendingTeamMembersState is PendingTeamMembersStateLoading ||
        pendingTeamMembersState is PendingTeamMembersStateInvited)
      return false;
    else
      return true;
  }

  void _searchUser() {
    if (_formKey.currentState!.validate()) {
      _teamMemberBloc.add(SearchMemberToTeamEvent(_teamNameController.text));
    }
  }

  void _inviteUser(TeamMemberState teamMemberState) {
    if (teamMemberState is TeamMemberStateUserFound) if (teamMemberState.userLookedFor.pendingInvitationsIds?.length !=
            null &&
        teamMemberState.userLookedFor.pendingInvitationsIds!.length <= 1) {
      _pendingTeamMembersBloc.add(InviteTeamMember(
        _team,
        teamMemberState.userLookedFor.uid,
      ));
    } else {
      EasyLoading.showInfo(
          'Nie możesz dodać tego użytkownika. ${teamMemberState.userLookedFor.displayName} ma zbyt wiele aktywnych zaproszeń');
    }
  }

  @override
  void initState() {
    _teamMemberBloc = Provider.of<TeamMemberBloc>(context, listen: false);
    _pendingTeamMembersBloc = Provider.of<PendingTeamMembersBloc>(context, listen: false);
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _team = Provider.of<TeamBloc>(context, listen: false).team;
    _pendingTeamMembers = _pendingTeamMembersBloc.pendingTeamMembers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamMemberBloc, TeamMemberState>(
      bloc: _teamMemberBloc,
      listener: (context, teamMemberState) {
        if (teamMemberState is TeamMemberStateUserFound) {
          dissmissCurrentFocus(context);
          _teamNameController.clear();
        }
        if (teamMemberState is TeamMemberStateError) {
          dissmissCurrentFocus(context);
          EasyLoading.showError(teamMemberState.errorMessage);
        }
      },
      builder: (context, teamMemberState) {
        return Container(
          padding: EdgeInsets.fromLTRB(Dimentions.medium, Dimentions.medium, Dimentions.medium, Dimentions.medium),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Dodaj znajomego',
                  style: Theme.of(context).textTheme.headline6,
                ),
                VerticalSizedBox8(),
                Text(
                  'Podaj maila zarejestrowanego użytkownika aplikacji',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                VerticalSizedBox16(),
                TextFormField(
                  controller: _teamNameController,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val! == _user.email
                      ? 'Nie możesz dodać siebie do swojego klanu'
                      : val.isEmpty || !val.contains('@')
                          ? 'Podaj poprawny adres email'
                          : null,
                  onEditingComplete: teamMemberState is TeamMemberStateLoading ? null : _searchUser,
                  keyboardType: TextInputType.emailAddress,
                ),
                VerticalSizedBox8(),
                CustomElevatedButton(
                  label: 'Szukaj użytkownika',
                  onPressed: teamMemberState is TeamMemberStateLoading ? null : _searchUser,
                ),
                if (teamMemberState is TeamMemberStateUserFound)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSizedBox16(),
                      Text(
                        'Znaleziono użytkownika',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(),
                        title: Text(
                            _pendingTeamMembers.indexWhere((el) => el.uid == teamMemberState.userLookedFor.uid) > -1
                                ? teamMemberState.userLookedFor.displayName.toString() + ' - wysłano'
                                : teamMemberState.userLookedFor.displayName.toString()),
                        subtitle: Text(teamMemberState.userLookedFor.email),
                        trailing: Column(
                          children: [
                            BlocConsumer<PendingTeamMembersBloc, PendingTeamMembersState>(
                                bloc: _pendingTeamMembersBloc,
                                listener: (context, pendingTeamMembersState) {
                                  if (pendingTeamMembersState is PendingTeamMembersStateInvited) {
                                    EasyLoading.showSuccess('Wysłano zaproszenie');
                                  }
                                },
                                builder: (context, pendingTeamMembersState) {
                                  return Container(
                                    color: _handleCanBeInvitedValidation(teamMemberState, pendingTeamMembersState)
                                        ? Palette.chaletBlue
                                        : Palette.grey,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Palette.white,
                                      ),
                                      onPressed: _handleCanBeInvitedValidation(teamMemberState, pendingTeamMembersState)
                                          ? () => _inviteUser(teamMemberState)
                                          : null,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

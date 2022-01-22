import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_bloc.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_event.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/team_member_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/team_repository.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class PendingTeamInvitationContainer extends StatefulWidget {
  final List<TeamMemberModel> teamMemberList;
  const PendingTeamInvitationContainer({
    Key? key,
    required this.teamMemberList,
  }) : super(key: key);

  @override
  State<PendingTeamInvitationContainer> createState() => _PendingTeamInvitationContainerState();
}

class _PendingTeamInvitationContainerState extends State<PendingTeamInvitationContainer> {
  late ReactToPendingInvitationBloc _reactToPendingInvitationBloc;
  late TeamMemberModel _admin;
  late UserModel _user;

  void _acceptInvitation() => _reactToPendingInvitationBloc.add(AcceptPendingInvitation(
        TeamMemberModel(
          id: _user.uid,
          name: _user.displayName ?? '',
          isAdmin: false,
          teamId: _admin.teamId,
          teamName: _admin.teamName,
        ),
        _admin.teamId,
      ));

  @override
  void initState() {
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _reactToPendingInvitationBloc = Provider.of<ReactToPendingInvitationBloc>(context, listen: false);
    _admin = widget.teamMemberList.firstWhere((el) => el.isAdmin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactToPendingInvitationBloc, ReactToPendingInvitationState>(listener: (context, state) {
      if (state is ReactToPendingInvitationStateAccepted) {
        EasyLoading.showSuccess('Udało się! Jesteś członkiem klanu ${_admin.teamName}');
      }
      if (state is ReactToPendingInvitationStateError) {
        EasyLoading.showError(state.errorMessage);
      }
    }, builder: (context, state) {
      return Column(
        children: [
          Text('Nazwa klanu'),
          Text('${_admin.teamName}'),
          Text('Członkowie'),
          ...widget.teamMemberList.map((member) => Text(member.name)),
          CustomElevatedButton(
            label: 'Zaakceptuj zaproszenie',
            onPressed: state is ReactToPendingInvitationStateLoading ? null : _acceptInvitation,
          ),
          CustomTextButton(
            onPressed: () {},
            label: 'Odrzuć zaproszenie',
            color: Palette.ivoryBlack,
          ),
        ],
      );
    });
  }
}

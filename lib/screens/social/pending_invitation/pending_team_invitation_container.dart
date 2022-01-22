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
  final String? otherTeamId;
  const PendingTeamInvitationContainer({
    Key? key,
    required this.teamMemberList,
    required this.otherTeamId,
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
        widget.otherTeamId,
      ));

  void _declineInvitation() => _reactToPendingInvitationBloc.add(DeclinePendingInvitation(_admin.teamId, _user.uid));

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
        Navigator.of(context).pop();
      }
      if (state is ReactToPendingInvitationStateDeclined) {
        EasyLoading.showSuccess('Odrzucono zaproszenie do klanu');
      }
      if (state is ReactToPendingInvitationStateError) {
        EasyLoading.showError(state.errorMessage);
      }
    }, builder: (context, state) {
      return state is ReactToPendingInvitationStateDeclined
          ? Container()
          : Container(
              margin: EdgeInsets.symmetric(vertical: Dimentions.medium),
              padding: EdgeInsets.all(Dimentions.small),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.lightGrey),
                borderRadius: BorderRadius.circular(Dimentions.medium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nazwa klanu',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    '${_admin.teamName}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  VerticalSizedBox8(),
                  Text(
                    'Członkowie',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  ...widget.teamMemberList.map((member) => Text(
                        member.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                      )),
                  VerticalSizedBox8(),
                  CustomElevatedButton(
                    label: 'Zaakceptuj zaproszenie',
                    onPressed: state is ReactToPendingInvitationStateLoading
                        ? null
                        : widget.otherTeamId == null
                            ? _acceptInvitation
                            : () => showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                      headline: 'Czy chcesz zaakceptować to zaproszenie',
                                      text: 'Przyjęcie tego zaproszenia spowoduje odrzucenie pozostałych',
                                      approveFunction: _acceptInvitation,
                                      approveFunctionButtonLabel: 'Zaakcpetuj',
                                    )),
                  ),
                  CustomTextButton(
                    onPressed: state is ReactToPendingInvitationStateLoading ? null : _declineInvitation,
                    label: 'Odrzuć zaproszenie',
                    color: Palette.ivoryBlack,
                  ),
                ],
              ),
            );
    });
  }
}

import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_bloc.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_event.dart';
import 'package:chalet/blocs/react_to_pending_invitation/react_to_pending_invitation_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/color_model.dart';
import 'package:chalet/models/team_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class PendingTeamInvitationContainer extends StatefulWidget {
  final TeamModel team;
  final String? otherTeamId;
  const PendingTeamInvitationContainer({
    Key? key,
    required this.team,
    required this.otherTeamId,
  }) : super(key: key);

  @override
  State<PendingTeamInvitationContainer> createState() => _PendingTeamInvitationContainerState();
}

class _PendingTeamInvitationContainerState extends State<PendingTeamInvitationContainer> {
  late ReactToPendingInvitationBloc _reactToPendingInvitationBloc;
  late UserModel _user;
  ColorModel? _choosenColor;

  void _handleChoosenColor(ColorModel color) {
    setState(() => _choosenColor = color);
    Navigator.of(context).pop();
  }

  void _acceptInvitation() => _reactToPendingInvitationBloc.add(AcceptPendingInvitation(
        _user.uid,
        widget.team.id,
        widget.otherTeamId,
        _choosenColor!.bitmapDescriptor,
      ));

  void _declineInvitation() => _reactToPendingInvitationBloc.add(DeclinePendingInvitation(widget.team.id, _user.uid));

  @override
  void initState() {
    _user = Provider.of<UserDataBloc>(context, listen: false).user;
    _reactToPendingInvitationBloc = Provider.of<ReactToPendingInvitationBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactToPendingInvitationBloc, ReactToPendingInvitationState>(listener: (context, state) {
      if (state is ReactToPendingInvitationStateAccepted) {
        EasyLoading.showSuccess('Udało się! Jesteś członkiem klanu ${widget.team.name}');
        Navigator.of(context).pop();
      }
      if (state is ReactToPendingInvitationStateDeclined) {
        EasyLoading.showSuccess('Odrzucono zaproszenie do klanu');
        if (widget.otherTeamId == null) {
          Navigator.of(context).pop();
        }
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
                    '${widget.team.name}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  VerticalSizedBox8(),
                  Text(
                    'Admin klanu',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    '${widget.team.teamAdminName}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (_choosenColor != null)
                    Column(
                      children: [
                        VerticalSizedBox8(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Wybrany kolor',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            HorizontalSizedBox16(),
                            CustomColorIndicator(
                              color: _choosenColor!.color,
                              isSelected: false,
                              onSelect: null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  VerticalSizedBox8(),
                  _choosenColor == null
                      ? CustomElevatedButton(
                          label: 'Wybierz kolor',
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => ColorPickerDialog(
                                    handleChoosenColor: _handleChoosenColor,
                                    alreadyChoosenColors: widget.team.choosenColors ?? [],
                                  )))
                      : CustomElevatedButton(
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

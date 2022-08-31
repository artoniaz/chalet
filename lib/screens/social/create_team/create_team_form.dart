import 'package:Challet/blocs/create_team/create_team_bloc.dart';
import 'package:Challet/blocs/create_team/create_team_event.dart';
import 'package:Challet/blocs/create_team/create_team_state.dart';
import 'package:Challet/blocs/team/team_state.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/config/functions/dissmis_focus.dart';
import 'package:Challet/models/color_model.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/styles/index.dart';
import 'package:Challet/styles/input_decoration.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CreateTeamForm extends StatefulWidget {
  final CreateTeamBloc createTeamBloc;
  final TextEditingController teamNameController;
  const CreateTeamForm({
    Key? key,
    required this.createTeamBloc,
    required this.teamNameController,
  }) : super(key: key);

  @override
  _CreateTeamFormState createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ColorModel? _choosenColor;
  bool _isTeamNameApproved = false;
  bool _isAllowApproveButton = false;

  void _handleChoosenColor(ColorModel color) {
    setState(() => _choosenColor = color);
    Navigator.of(context).pop();
  }

  void _addTeam() {
    if (_formKey.currentState!.validate() && _choosenColor != null) {
      UserModel user = Provider.of<UserDataBloc>(context, listen: false).state.props.first as UserModel;
      widget.createTeamBloc.add(AddCreateTeamEvent(
        user.uid,
        user.displayName ?? '',
        widget.teamNameController.text,
        _choosenColor!.bitmapDescriptor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTeamBloc, CreateTeamState>(
      bloc: widget.createTeamBloc,
      builder: (context, teamState) {
        return Container(
          padding: EdgeInsets.fromLTRB(Dimentions.medium, Dimentions.medium, Dimentions.medium, Dimentions.medium),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Dodaj klan',
                  style: Theme.of(context).textTheme.headline6,
                ),
                VerticalSizedBox8(),
                Text(
                  'Podaj nazwę klanu',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                VerticalSizedBox16(),
                TextFormField(
                  controller: widget.teamNameController,
                  decoration: textInputDecoration.copyWith(hintText: 'Nazwa klanu').copyWith(
                      fillColor:
                          _isTeamNameApproved && !_isAllowApproveButton ? Palette.chaletBlue : Palette.veryLightGrey),
                  validator: (val) => val!.isEmpty
                      ? 'Podaj poprawną nazwę klanu'
                      : val.length <= 3
                          ? 'Nazwa klanu musi mieć min. 3 znaki'
                          : null,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: _isTeamNameApproved,
                  onChanged: (val) {
                    if (val.length > 3 && !_isAllowApproveButton)
                      setState(() => _isAllowApproveButton = true);
                    else if (val.length <= 3 && _isAllowApproveButton) setState(() => _isAllowApproveButton = false);
                  },
                ),
                VerticalSizedBox8(),
                CustomElevatedButton(
                    label: _isTeamNameApproved && !_isAllowApproveButton
                        ? 'Nazwa klanu zatwierdzona'
                        : 'Potwierdź nazwę klanu',
                    onPressed: _isAllowApproveButton
                        ? () => setState(
                              () {
                                _isTeamNameApproved = true;
                                _isAllowApproveButton = false;
                              },
                            )
                        : null),
                if (_isTeamNameApproved)
                  Column(
                    crossAxisAlignment: _choosenColor == null ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
                    children: [
                      VerticalSizedBox16(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _choosenColor == null
                              ? Text(
                                  'Wybierz swój kolor',
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              : Text(
                                  'Wybrany kolor:',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                          HorizontalSizedBox8(),
                          if (_choosenColor != null)
                            CustomColorIndicator(
                              color: _choosenColor!.color,
                              isSelected: true,
                              onSelect: () {},
                            )
                        ],
                      ),
                      VerticalSizedBox8(),
                      _choosenColor == null
                          ? CustomElevatedButton(
                              label: 'Wybierz swój kolor',
                              onPressed: () {
                                dissmissCurrentFocus(context);
                                return showDialog(
                                    context: context,
                                    builder: (context) => ColorPickerDialog(
                                          handleChoosenColor: _handleChoosenColor,
                                          alreadyChoosenColors: [],
                                        ));
                              })
                          : CustomMainElevatedButton(
                              label: 'Dodaj klan',
                              onPressed: teamState is TeamStateLoading ? null : _addTeam,
                              backgroundColor: Palette.goldLeaf,
                            ),
                      if (_choosenColor == null)
                        Column(
                          children: [
                            VerticalSizedBox8(),
                            Text(
                              'Wybierz swój kolor w użytku wewnątrz klanu. Twoi znajomi z klanu zobaczą Twoje osiągnięcia / Szalety oznaczone tym kolorem.',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        )
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

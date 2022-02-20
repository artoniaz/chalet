import 'package:chalet/blocs/create_team/create_team_bloc.dart';
import 'package:chalet/blocs/create_team/create_team_event.dart';
import 'package:chalet/blocs/create_team/create_team_state.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/input_decoration.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void _addTeam() {
    if (_formKey.currentState!.validate()) {
      UserModel user = Provider.of<UserDataBloc>(context, listen: false).state.props.first as UserModel;
      widget.createTeamBloc.add(AddCreateTeamEvent(user.uid, user.displayName ?? '', widget.teamNameController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTeamBloc, CreateTeamState>(
      bloc: widget.createTeamBloc,
      listener: (context, teamState) {},
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
                  decoration: textInputDecoration.copyWith(hintText: 'Nazwa klanu'),
                  validator: (val) => val!.isEmpty || val.length < 3 ? 'Podaj poprawny nazwę klanu' : null,
                  onEditingComplete: teamState is TeamStateLoading ? null : _addTeam,
                  keyboardType: TextInputType.emailAddress,
                ),
                VerticalSizedBox8(),
                CustomElevatedButton(
                  label: 'Dodaj klan',
                  onPressed: teamState is TeamStateLoading ? null : _addTeam,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

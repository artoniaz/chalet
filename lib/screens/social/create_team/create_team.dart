import 'package:chalet/blocs/create_team/create_team_bloc.dart';
import 'package:chalet/blocs/create_team/create_team_event.dart';
import 'package:chalet/blocs/create_team/create_team_state.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  late CreateTeamBloc _createTeamBloc;
  TextEditingController _teamNameController = TextEditingController();

  Future _whenComleteModalCreateTeam() async {
    _teamNameController.clear();
    _createTeamBloc.add(ResetCreateTeamBloc());
  }

  @override
  void initState() {
    _createTeamBloc = Provider.of<CreateTeamBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: BlocConsumer<CreateTeamBloc, CreateTeamState>(
            bloc: _createTeamBloc,
            listener: (context, state) async {
              if (state is CreateTeamStateError) {
                await _whenComleteModalCreateTeam();
                Navigator.of(context).pop();
                EasyLoading.showError(state.errorMessage);
              }
              if (state is CreateTeamStateTeamCreated) {
                Navigator.of(context).pop();
                EasyLoading.showSuccess('Utworzono klan');
              }
            },
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.fromLTRB(Dimentions.medium, 180.0, Dimentions.medium, Dimentions.medium),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Nie należysz jeszcze do żadnego klanu',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
                      ),
                      VerticalSizedBox24(),
                      Text(
                        'Kliknij, aby założyć swój klan i dołącz do naszej społeczności. Rywalizuj ze znajomymi i wspólnie osiągajcie sukcesy.',
                        textAlign: TextAlign.center,
                      ),
                      VerticalSizedBox16(),
                      CustomElevatedButton(
                          label: 'Załóż swój klan',
                          onPressed: () => showCustomModalBottomSheet(context, (context) {
                                return BlocConsumer<CreateTeamBloc, CreateTeamState>(
                                  bloc: _createTeamBloc,
                                  listener: (context, teamState) {},
                                  builder: (context, teamState) {
                                    if (teamState is CreateTeamStateInitial) {
                                      return CreateTeamForm(
                                        createTeamBloc: _createTeamBloc,
                                        teamNameController: _teamNameController,
                                      );
                                    }
                                    if (teamState is CreateTeamStateLoading) {
                                      return SpinKitChasingDots(
                                        color: Palette.chaletBlue,
                                        size: 50,
                                      );
                                    }
                                    if (teamState is CreateTeamStateTeamCreated) {
                                      return Container();
                                    } else
                                      return Container(
                                        child: Text('Wystąpił niespodziewany błąd.'),
                                      );
                                  },
                                );
                              }).whenComplete(() {
                                _whenComleteModalCreateTeam();
                              }))
                    ]),
              );
            }),
      ),
    );
  }
}

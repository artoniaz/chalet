import 'package:chalet/blocs/team/team_bloc.dart';
import 'package:chalet/blocs/team/team_event.dart';
import 'package:chalet/blocs/team/team_state.dart';
import 'package:chalet/blocs/team_member/team_member_bloc.dart';
import 'package:chalet/blocs/team_member/team_member_event.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  late TeamBloc _teamBloc;
  TextEditingController _teamNameController = TextEditingController();

  Future _whenComleteModalCreateTeam() async {
    _teamNameController.clear();
    _teamBloc.add(ResetTeamBloc());
  }

  @override
  void initState() {
    _teamBloc = Provider.of<TeamBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: BlocConsumer<TeamBloc, TeamState>(
            bloc: _teamBloc,
            listener: (context, state) async {
              if (state is TeamStateError) {
                await _whenComleteModalCreateTeam();
                Navigator.of(context).pop();
                EasyLoading.showError(state.errorMessage);
              }
            },
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(Dimentions.medium),
                child: Column(
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
                          onPressed: () => showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.3,
                                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                                  ),
                                  builder: (context) {
                                    return BlocBuilder<TeamBloc, TeamState>(
                                      bloc: _teamBloc,
                                      builder: (context, teamState) {
                                        if (teamState is TeamStateInitial) {
                                          return CreateTeamForm(
                                            teamBloc: _teamBloc,
                                            teamNameController: _teamNameController,
                                          );
                                        }
                                        if (teamState is TeamStateTeamCreated) {
                                          return AddMemberToTeam();
                                        } else
                                          return Loading();
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

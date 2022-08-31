import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/blocs/user_data/user_data_state.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SocialHome extends StatefulWidget {
  const SocialHome({Key? key}) : super(key: key);

  @override
  _SocialHomeState createState() => _SocialHomeState();
}

class _SocialHomeState extends State<SocialHome> {
  late UserDataBloc _userDataBloc;

  @override
  void initState() {
    _userDataBloc = Provider.of<UserDataBloc>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
        bloc: _userDataBloc,
        builder: (context, userDataState) {
          if (userDataState is UserDataStateLoaded) {
            if (userDataState.user.teamId == '') {
              return CreateTeam();
            } else
              return SocialMainPage();
          } else
            return Loading();
        });
  }
}

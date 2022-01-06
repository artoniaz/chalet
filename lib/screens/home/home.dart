import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/geolocation/geolocation_event.dart';
import 'package:chalet/blocs/geolocation/geolocation_state.dart';
import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_event.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GeolocationBloc _geolocatinBloc;
  late UserDataBloc _userDataBloc;
  int _currentIndex = 0;

  final List<Widget> tabs = [
    ChaletPageSelection(),
    SocialHome(),
    ProfileCard(),
  ];

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    firebaseUser.User? user = Provider.of<firebaseUser.User?>(context, listen: false);
    _geolocatinBloc = Provider.of<GeolocationBloc>(context, listen: false);
    _userDataBloc = Provider.of<UserDataBloc>(context, listen: false);
    _geolocatinBloc.add(GetUserGeolocation());
    _userDataBloc.add(GetUserData(user!.uid));
    super.initState();
  }

  @override
  void dispose() {
    _geolocatinBloc.close();
    // _userDataBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
        bloc: _userDataBloc,
        builder: (context, userDataState) {
          return BlocBuilder<GeolocationBloc, GeolocationState>(
              bloc: _geolocatinBloc,
              builder: (context, geolocationState) {
                if (geolocationState is GeolocationStateInitial ||
                    geolocationState is GeolocationStateLoading ||
                    userDataState is UserDataStateLoading)
                  return Loading();
                else if ((geolocationState is GeolocationStateLoaded || geolocationState is GeolocationStateError) &&
                    userDataState is UserDataStateLoaded)
                  return Scaffold(
                    extendBody: true,
                    body: IndexedStack(
                      index: _currentIndex,
                      children: tabs,
                    ),
                    bottomNavigationBar: BottomNavBar(
                      currentIndex: _currentIndex,
                      handleTabChange: handleTabChange,
                    ),
                  );
                else
                  return Container();
              });
        });
  }
}

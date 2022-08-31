import 'package:Challet/blocs/damaging_model/damaging_model_bloc.dart';
import 'package:Challet/blocs/damaging_model/damaging_model_event.dart';
import 'package:Challet/blocs/geolocation/geolocation_bloc.dart';
import 'package:Challet/blocs/geolocation/geolocation_event.dart';
import 'package:Challet/blocs/geolocation/geolocation_state.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/blocs/user_data/user_data_event.dart';
import 'package:Challet/blocs/user_data/user_data_state.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    firebaseUser.User? user = Provider.of<firebaseUser.User?>(context, listen: false);
    _geolocatinBloc = Provider.of<GeolocationBloc>(context, listen: false);
    _userDataBloc = Provider.of<UserDataBloc>(context, listen: false);
    _geolocatinBloc.add(GetUserGeolocation());
    _userDataBloc.add(GetUserData(user!.uid));
    Provider.of<DamagingDeviceModelBloc>(context, listen: false).add(CheckDamagingDeviceModelEvent());
    super.initState();
  }

  @override
  void dispose() {
    _geolocatinBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
        bloc: _userDataBloc,
        builder: (context, userDataState) {
          return BlocConsumer<GeolocationBloc, GeolocationState>(
              bloc: _geolocatinBloc,
              listener: (context, geolocationState) {
                if (geolocationState is GeolocationStateError) {
                  EasyLoading.showInfo(geolocationState.errorMessage);
                }
              },
              builder: (context, geolocationState) {
                if (geolocationState is GeolocationStateInitial ||
                    geolocationState is GeolocationStateLoading ||
                    userDataState is UserDataStateLoading)
                  return Loading();
                else if ((geolocationState is GeolocationStateLoaded || geolocationState is GeolocationStateError) &&
                    userDataState is UserDataStateLoaded)
                  return Scaffold(
                    appBar: userDataState.user.pendingInvitationsIds == null ||
                            userDataState.user.pendingInvitationsIds!.isEmpty
                        ? null
                        : CustomAppBars.customPendingTeamInfoAppBar(context),
                    extendBody: true,
                    body: IndexedStack(
                      index: _currentIndex,
                      children: [
                        ChaletPageSelection(),
                        SocialHome(),
                        ProfileCard(),
                      ],
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

import 'package:chalet/blocs/geolocation/geolocation_bloc.dart';
import 'package:chalet/blocs/geolocation/geolocation_event.dart';
import 'package:chalet/blocs/geolocation/geolocation_state.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GeolocationBloc _geolocatinBloc;
  int _currentIndex = 0;

  final List<Widget> tabs = [
    ChaletPageSelection(),
    ProfileCard(),
  ];

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    _geolocatinBloc = Provider.of<GeolocationBloc>(context, listen: false);
    _geolocatinBloc.add(GetUserGeolocation());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeolocationBloc, GeolocationState>(
        bloc: _geolocatinBloc,
        builder: (context, state) {
          if (state is GeolocationStateInitial || state is GeolocationStateLoading) return Loading();
          if (state is GeolocationStateLoaded)
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
            return Loading();
        });
  }
}

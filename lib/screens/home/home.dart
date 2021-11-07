import 'package:chalet/providers/image_file_list_provider_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/geolocation_service.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late LatLng _userLocation;
  bool _isScreenLoading = true;

  final List<Widget> tabs = [
    ChaletPageSelection(),
    ChangeNotifierProvider(create: (context) => ImageFileListModel(), child: AddChalet()),
    ProfileCard(),
  ];

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  void getInitData() async {
    try {
      final _location = await GeolocationService().getUserLocation();
      setState(() {
        _userLocation = _location;
        _isScreenLoading = false;
      });
    } catch (e) {
      setState(() {
        _userLocation = LatLng(52.23749905, 21.018166594);
        _isScreenLoading = false;
      });
    }
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isScreenLoading
        ? Loading()
        : Provider<LatLng>(
            create: (context) => _userLocation,
            child: Scaffold(
              body: tabs[_currentIndex],
              bottomNavigationBar: BottomNavBar(
                currentIndex: _currentIndex,
                handleTabChange: handleTabChange,
              ),
            ),
          );
  }
}

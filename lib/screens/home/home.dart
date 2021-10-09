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
  final List<Widget> tabs = [
    ChaletList(),
    StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return ChaletMap();
        }),
    ChangeNotifierProvider(create: (context) => ImageFileListModel(), child: AddChalet()),
  ];

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        handleTabChange: handleTabChange,
      ),
    );
  }
}

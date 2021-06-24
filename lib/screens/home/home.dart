import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
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
    Center(
      child: Text('mapa'),
    ),
    AddChalet(),
  ];

  void handleTabChange(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    // final AuthService _authService = new AuthService();
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        handleTabChange: handleTabChange,
      ),
    );
  }
}

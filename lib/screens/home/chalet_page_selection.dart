import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/styles/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class ChaletPageSelection extends StatefulWidget {
  const ChaletPageSelection({Key? key}) : super(key: key);

  @override
  _ChaletPageSelectionState createState() => _ChaletPageSelectionState();
}

class _ChaletPageSelectionState extends State<ChaletPageSelection> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ChaletList(),
          ChaletMap(),
        ],
      ),
      Positioned(
        top: Dimentions.small,
        child: SafeArea(
          child: FlutterToggleTab(
            width: 100 - Dimentions.small,
            borderRadius: 30,
            height: 35,
            selectedIndex: _tabController.index,
            selectedTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            unSelectedTextStyle: TextStyle(color: Palette.ivoryBlack, fontSize: 12, fontWeight: FontWeight.w500),
            selectedBackgroundColors: [Palette.chaletBlue],
            labels: [
              "Lista",
              "Mapa",
            ],
            selectedLabelIndex: (index) {
              print("Selected Index $index");
              setState(() {
                _tabController.animateTo(index);
              });
            },
          ),
        ),
      ),
    ]);
  }
}

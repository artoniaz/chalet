import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) handleTabChange;
  const BottomNavBar({Key? key, required this.currentIndex, required this.handleTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Palette.ivoryBlack,
      unselectedItemColor: Palette.chaletBlue,
      selectedItemColor: Palette.goldLeaf,
      currentIndex: currentIndex,
      onTap: (index) => handleTabChange(index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Szalety'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.map_sharp,
            ),
            label: 'Mapa'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Dodaj szalet'),
      ],
    );
  }
}

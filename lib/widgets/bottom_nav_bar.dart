import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) handleTabChange;
  const BottomNavBar({Key? key, required this.currentIndex, required this.handleTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        items: const [
          // BottomNavigationBarItem(
          //     icon: PlatformSvgAsset(
          //       assetName: 'chalets',
          //       width: 26,
          //       height: 26.0,
          //     ),
          //     label: 'Szalety'),
          BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Szalety'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mój profil'),
        ],
        elevation: 2.0,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Palette.chaletBlue,
        unselectedItemColor: Palette.backgroundWhite,
        selectedItemColor: Palette.backgroundWhite,
        selectedFontSize: 16.0,
        currentIndex: currentIndex,
        onTap: (index) => handleTabChange(index),
      ),
    );
  }
}

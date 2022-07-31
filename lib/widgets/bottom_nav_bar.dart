import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';

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
      child: CustomLineIndicatorBottomNavbar(
        selectedColor: Palette.white,
        unSelectedColor: Palette.ivoryBlack,
        backgroundColor: Palette.chaletBlue,
        currentIndex: currentIndex,
        enableLineIndicator: true,
        lineIndicatorWidth: 3.0,
        indicatorType: IndicatorType.Top,
        onTap: (index) => handleTabChange(index),
        customBottomBarItems: [
          CustomBottomBarItems(icon: Icons.wc, label: 'Szalety'),
          CustomBottomBarItems(icon: Icons.public, label: 'Social'),
          CustomBottomBarItems(icon: Icons.person, label: 'Mój profil'),
        ],
      ),
      // child: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Szalety'),
      //     BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Social'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mój profil'),
      //   ],
      //   elevation: 2.0,
      //   showUnselectedLabels: true,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Palette.unselectedBackgroundGrey,
      //   unselectedItemColor: Palette.ivoryBlack,
      //   selectedItemColor: Palette.chaletBlue,
      //   selectedFontSize: 16.0,
      //   currentIndex: currentIndex,
      //   onTap: (index) => handleTabChange(index),
      // ),
    );
  }
}

import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/screens/my_profile/change_password.dart';
import 'package:chalet/services/auth_service.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileDrawer extends StatelessWidget {
  final PanelController panelController;
  final PackageInfo? packageInfo;
  final UserModel? user;
  const ProfileDrawer({
    Key? key,
    required this.panelController,
    required this.packageInfo,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(Dimentions.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    child: Image(
                      width: 80.0,
                      height: 80.0,
                      image: AssetImage('assets/poo/poo_happy.png'),
                    ),
                  ),
                  CustomElevatedButton(
                    label: 'Edytuj dane',
                    onPressed: () {
                      Navigator.pop(context);
                      panelController.open();
                    },
                  ),
                  VerticalSizedBox16(),
                  CustomElevatedButton(
                    label: 'Zmień hasło',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimentions.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextButton(
                    label: 'Wyloguj',
                    color: Palette.ivoryBlack,
                    onPressed: () => AuthService().signOut(),
                  ),
                  CustomTextButton(
                    label: 'Usuń profil',
                    color: Palette.ivoryBlack,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => RemoveAccountDialog(
                        userEmail: user!.email,
                      ),
                    ),
                  ),
                  packageInfo != null
                      ? Text(
                          'wersja aplikacji: ${packageInfo!.version}',
                          textAlign: TextAlign.center,
                        )
                      : CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

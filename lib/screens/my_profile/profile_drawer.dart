import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_event.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/screens/my_profile/change_password.dart';
import 'package:chalet/services/auth_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileDrawer extends StatelessWidget {
  final PanelController panelController;
  final PackageInfo? packageInfo;
  final UserModel user;
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
        padding: const EdgeInsets.symmetric(
          vertical: Dimentions.medium,
          horizontal: Dimentions.horizontalPadding,
        ),
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
                    child: MainImage(),
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
            BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(Dimentions.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextButton(
                      label: 'Wyloguj',
                      color: Palette.ivoryBlack,
                      onPressed: () async {
                        await AuthService().signOut();
                        Provider.of<UserDataBloc>(context, listen: false).add(GetUserDataInitialState());
                      },
                    ),
                    CustomTextButton(
                      label: 'Usuń profil',
                      color: Palette.ivoryBlack,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => RemoveAccountDialog(
                          userId: user.uid,
                          userEmail: user.email,
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
                    BottomContainer(
                      height: 42.0,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

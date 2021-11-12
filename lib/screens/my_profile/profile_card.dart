import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:package_info/package_info.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final _panelController = PanelController();
  PackageInfo? _packageInfo;

  TextEditingController _userDisplayNameController = TextEditingController();

  void _updateDisplayname() async {
    try {
      await AuthService().editUserData(_userDisplayNameController.text);
      _panelController.close();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  void _getPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  void initState() {
    _getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final node = FocusScope.of(context);

    return StreamBuilder<UserModel?>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SafeArea(
                          child: CustomCircleAvatar(
                            photoURL: user!.photoURL,
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: true,
                        fillOverscroll: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Column(
                              children: [
                                Divider(),
                                Text(
                                  user.displayName ?? '',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                VerticalSizedBox8(),
                                Text(
                                  user.email,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            )),
                            Container(
                              padding: EdgeInsets.all(Dimentions.small),
                              child: Column(
                                children: [
                                  CustomElevatedButton(
                                    label: 'Edytuj dane',
                                    onPressed: () => _panelController.open(),
                                  ),
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
                                        userEmail: user.email,
                                      ),
                                    ),
                                  ),
                                  _packageInfo != null
                                      ? Text('wersja aplikacji: ${_packageInfo!.version}')
                                      : CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SlidingUpPanel(
                    padding: EdgeInsets.fromLTRB(Dimentions.small, 24, Dimentions.small, Dimentions.small),
                    backdropEnabled: true,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(48.0)),
                    minHeight: 0.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    onPanelClosed: () => dissmissCurrentFocus(context),
                    controller: _panelController,
                    panel: GestureDetector(
                      onTap: () => dissmissCurrentFocus(context),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: 'Nazwa użytkownika'),
                            controller: _userDisplayNameController,
                            onEditingComplete: () => node.nextFocus(),
                            keyboardType: TextInputType.text,
                          ),
                          VerticalSizedBox16(),
                          CustomElevatedButton(
                            label: 'Zapisz dane',
                            onPressed: _updateDisplayname,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else
            return Container();
        });
  }
}

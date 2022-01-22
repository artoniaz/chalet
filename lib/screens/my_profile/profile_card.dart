import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_state.dart';
import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/config/routes/routes_definitions.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:chalet/screens/my_profile/personal_number_dialogs.dart';
import 'package:chalet/screens/my_profile/profile_drawer.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late UserDataBloc _userDataBloc;
  late UserModel _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _panelController = PanelController();
  PackageInfo? _packageInfo;
  FocusNode _personalNumberFocusNode = FocusNode();
  FocusNode _userNameFocusNode = FocusNode();
  bool _hasPersonalNumberBeenFocused = false;
  bool _isUpdateButtonActive = false;

  TextEditingController _userDisplayNameController = TextEditingController();
  TextEditingController _personalNumberTextController = TextEditingController();

  void _checkIsUpdateButtonActive() {
    _userDisplayNameController.addListener(() {
      if (_userDisplayNameController.text.isNotEmpty || _personalNumberTextController.text.length == 9) {
        setState(() => _isUpdateButtonActive = true);
      }
    });
    _personalNumberTextController.addListener(() {
      if (_userDisplayNameController.text.isNotEmpty || _personalNumberTextController.text.length == 9) {
        setState(() => _isUpdateButtonActive = true);
      }
    });
  }

  void _updateDisplayname() async {
    if (_formKey.currentState!.validate() && _userDisplayNameController.text.isNotEmpty) {
      try {
        await UserDataRepository().updateUserDisplayName(_user.uid, _userDisplayNameController.text);
        dissmissCurrentFocus(context);
        _personalNumberFocusNode.unfocus();
        _userNameFocusNode.unfocus();
        _panelController.close();
        if (_personalNumberTextController.text.length == 9) {
          showDialog(
              context: context,
              builder: (context) {
                return PersonalNumberConfirmDialog(
                  hasAlsoUserNameChanged: true,
                );
              });
        }
        _personalNumberTextController.clear();
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    } else if (_userDisplayNameController.text.isEmpty && _personalNumberTextController.text.length == 9) {
      _personalNumberTextController.clear();
      _personalNumberFocusNode.unfocus();
      _userNameFocusNode.unfocus();
      showDialog(
          context: context,
          builder: (context) {
            return PersonalNumberConfirmDialog(
              hasAlsoUserNameChanged: false,
            );
          });
    }
  }

  void _getPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  void initState() {
    _userDataBloc = Provider.of<UserDataBloc>(context, listen: false);
    _user = context.read<UserDataBloc>().state.props.first as UserModel;

    _getPackageInfo();
    _checkIsUpdateButtonActive();
    _personalNumberFocusNode.addListener(() {
      if (_personalNumberFocusNode.hasFocus && !_hasPersonalNumberBeenFocused) {
        setState(() => _hasPersonalNumberBeenFocused = true);
        _personalNumberFocusNode.unfocus();
        showDialog(
            context: context,
            builder: (context) {
              return SeriouslyDialog();
            });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _personalNumberFocusNode.dispose();
    _userNameFocusNode.dispose();
    _userDisplayNameController.dispose();
    _personalNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
        bloc: _userDataBloc,
        builder: (context, state) {
          if (state is UserDataStateLoaded) {
            final user = state.user;
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Palette.chaletBlue),
                backgroundColor: Colors.transparent,
              ),
              resizeToAvoidBottomInset: false,
              drawer: ProfileDrawer(
                panelController: _panelController,
                packageInfo: _packageInfo,
                user: user,
              ),
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SafeArea(
                          child: CustomCircleAvatar(
                            photoURL: user.photoURL,
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
                                  style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w700),
                                ),
                                VerticalSizedBox16(),
                                Text(
                                  user.email,
                                  style: Theme.of(context).textTheme.headline6!.copyWith(color: Palette.grey),
                                ),
                                VerticalSizedBox16(),
                                if (user.pendingInvitationsIds != null && user.pendingInvitationsIds!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomElevatedButton(
                                        label: 'Zobacz zaproszenia do klanu',
                                        onPressed: () =>
                                            Navigator.pushNamed(context, RoutesDefinitions.VIEW_PENDING_INVITATIONS),
                                      ),
                                      VerticalSizedBox8(),
                                      Text(
                                        'Możesz mieć tylko 2 aktywne zaproszenia. Decyduj szybko!',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.grey),
                                      ),
                                    ],
                                  ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SlidingUpPanel(
                    padding:
                        EdgeInsets.fromLTRB(Dimentions.medium, Dimentions.large, Dimentions.medium, Dimentions.medium),
                    backdropEnabled: true,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(48.0)),
                    minHeight: 0.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    onPanelClosed: () {
                      _personalNumberFocusNode.unfocus();
                      _userNameFocusNode.unfocus();
                      _personalNumberTextController.clear();
                      _userDisplayNameController.clear();
                      setState(() => _isUpdateButtonActive = false);
                    },
                    // onPanelOpened: () => _userDisplayNameController.text = user.displayName ?? '',
                    controller: _panelController,
                    panel: GestureDetector(
                      onTap: () => dissmissCurrentFocus(context),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: user.displayName == '' ? 'Nazwa użytkownika' : user.displayName),
                              controller: _userDisplayNameController,
                              focusNode: _userNameFocusNode,
                              keyboardType: TextInputType.text,
                              validator: (val) => val!.length > 0 && val.length < 3
                                  ? 'Nazwa użytkownika musi zawierać miniumum 3 znaki'
                                  : null,
                            ),
                            VerticalSizedBox16(),
                            TextFormField(
                              controller: _personalNumberTextController,
                              decoration: textInputDecoration.copyWith(hintText: 'Numer PESEL'),
                              keyboardType: _hasPersonalNumberBeenFocused ? TextInputType.number : TextInputType.none,
                              focusNode: _personalNumberFocusNode,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              maxLength: 9,
                            ),
                            VerticalSizedBox16(),
                            CustomElevatedButton(
                              label: 'Zapisz dane',
                              onPressed: _isUpdateButtonActive ? _updateDisplayname : null,
                            ),
                          ],
                        ),
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

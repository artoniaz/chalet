import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/auth_service.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/input_decoration.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPasswordConfirmController = TextEditingController();

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserModel? user = context.read<UserDataBloc>().state.props.first as UserModel;

        await AuthService().changeUserPassword(user.email, _oldPasswordController.text, _newPasswordController.text);
        EasyLoading.showSuccess('Zmienino hasło');
        Navigator.pop(context);
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return GestureDetector(
      onTap: () => dissmissCurrentFocus(context),
      child: Scaffold(
        appBar: CustomAppBars.customAppBarChaletBlue(context, 'Zmień hasło'),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimentions.medium,
            horizontal: Dimentions.horizontalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: textInputDecoration.copyWith(hintText: 'Stare hasło'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Stare hasło musi zawierać minimum 6 znaków' : null,
                  onEditingComplete: () => node.nextFocus(),
                ),
                VerticalSizedBox16(),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: textInputDecoration.copyWith(hintText: 'Nowe hasło'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Hasło musi zawierać minimum 6 znaków' : null,
                  onEditingComplete: () => node.nextFocus(),
                ),
                VerticalSizedBox16(),
                TextFormField(
                  controller: _newPasswordConfirmController,
                  decoration: textInputDecoration.copyWith(hintText: 'Potwierdź hasło'),
                  obscureText: true,
                  validator: (val) => val != _newPasswordController.text ? 'Hasła muszą być zgodne' : null,
                  onEditingComplete: () => _updatePassword(),
                ),
                VerticalSizedBox24(),
                CustomElevatedButton(
                  label: 'Zmień hasło',
                  onPressed: _updatePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

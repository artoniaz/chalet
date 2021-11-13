import 'package:chalet/config/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  Future _sendEmailResetPassword() async {
    try {
      final email = _emailController.text.trim();
      await AuthService().sendPasswordResetEmail(email);
      Navigator.of(context).pop();
      EasyLoading.showInfo(
        'Sprawdź swój email ${email} w celu zmiany hasła.',
        duration: Duration(seconds: 5),
        dismissOnTap: true,
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return GestureDetector(
      onTap: () => dissmissCurrentFocus(context),
      child: Scaffold(
          appBar: CustomAppBars.customAppBarDark(context, 'Zapomniałem hasła'),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding, vertical: Dimentions.large),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => val!.isEmpty || !val.contains('@') ? 'Podaj poprawny adres email' : null,
                          onEditingComplete: () => node.nextFocus(),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        VerticalSizedBox16(),
                        CustomElevatedButton(
                          label: 'Zmień hasło',
                          onPressed: _sendEmailResetPassword,
                        ),
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}

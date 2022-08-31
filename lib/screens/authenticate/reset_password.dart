import 'package:Challet/config/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:Challet/services/index.dart';
import 'package:Challet/styles/index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  Future _sendEmailResetPassword() async {
    try {
      final email = _emailController.text.trim();
      await AuthService().sendPasswordResetEmail(email);
      Navigator.of(context).pop();
      EasyLoading.showInfo(
        'Sprawdź swój email $email w celu zmiany hasła.',
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
          appBar: CustomAppBars.customTransparentAppBar(context),
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
                        MainImage(),
                        VerticalSizedBox16(),
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

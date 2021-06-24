import 'package:chalet/config/index.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:chalet/styles/index.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  String email = '';
  String error = '';

  bool isLoading = false;

  Future registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      email = email.trim();
      passwordController.text = passwordController.text.trim();
      try {
        await _authService.registerWithEmailAndPassword(
            email, passwordController.text);
      } catch (e) {
        setState(() {
          passwordController.clear();
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return isLoading
        ? Loading()
        : GestureDetector(
            onTap: () => dissmissCurrentFocus(context),
            child: Scaffold(
                appBar: CustomAppBars.customAppBarDark(context, 'Rejestracja'),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimentions.horizontalPadding,
                        vertical: Dimentions.large),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) =>
                                  val!.isEmpty || !val.contains('@')
                                      ? 'Podaj poprawny adres email'
                                      : null,
                              onChanged: (String val) =>
                                  setState(() => email = val),
                              onEditingComplete: () => node.nextFocus(),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            VerticalSizedBox16(),
                            TextFormField(
                              controller: passwordController,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Hasło'),
                              obscureText: true,
                              validator: (val) => val!.length < 6
                                  ? 'Hasło musi zawierać minimum 6 znaków'
                                  : null,
                              onEditingComplete: () =>
                                  registerWithEmailAndPassword(),
                            ),
                            VerticalSizedBox16(),
                            CustomElevatedButton(
                              label: 'Rejestracja',
                              onPressed: registerWithEmailAndPassword,
                            ),
                            if (error.isNotEmpty) VerticalSizedBox16(),
                            Text(
                              error,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Palette.errorRed),
                            ),
                            if (error.isNotEmpty) VerticalSizedBox16(),
                            CustomTextButton(
                              onPressed: widget.toggleView,
                              label: 'Masz już konto? Zaloguj się.',
                            )
                          ],
                        )),
                  ),
                )),
          );
  }
}

import 'package:chalet/config/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:chalet/services/index.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({
    Key? key,
    required this.toggleView,
  }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String error = '';

  bool isLoading = false;

  Future signUpWIthEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      email = email.trim();
      passwordController.text = passwordController.text.trim();
      try {
        await _authService.signInWithEmailAndPassword(email, passwordController.text);
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
                body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimentions.horizontalPadding, vertical: Dimentions.large),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              width: 80.0,
                              height: 80.0,
                              image: AssetImage('assets/poo/poo_happy.png'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                                  validator: (val) =>
                                      val!.isEmpty || !val.contains('@') ? 'Podaj poprawny adres email' : null,
                                  onChanged: (String val) => setState(() => email = val),
                                  onEditingComplete: () => node.nextFocus(),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                VerticalSizedBox16(),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: textInputDecoration.copyWith(hintText: 'Hasło'),
                                  obscureText: true,
                                  validator: (val) => val!.length < 6 ? 'Hasło musi zawierać minimum 6 znaków' : null,
                                  onEditingComplete: () => signUpWIthEmailAndPassword(),
                                ),
                                VerticalSizedBox16(),
                                CustomElevatedButton(
                                  label: 'Zaloguj się',
                                  onPressed: signUpWIthEmailAndPassword,
                                ),
                                Row(children: <Widget>[
                                  Expanded(child: Divider()),
                                  HorizontalSizedBox8(),
                                  Text("lub"),
                                  HorizontalSizedBox8(),
                                  Expanded(child: Divider()),
                                ]),
                                CustomElevatedButton(
                                  label: 'Utwórz nowe konto',
                                  onPressed: widget.toggleView,
                                ),
                                if (error.isNotEmpty) VerticalSizedBox16(),
                                Text(
                                  error,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.errorRed),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SignInButton(
                                  Buttons.Facebook,
                                  text: 'Zaloguj przez Facebook',
                                  onPressed: () => AuthService().facebookAuth(),
                                ),
                                if (error.isNotEmpty) VerticalSizedBox16(),
                                CustomTextButton(
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ResetPassword())),
                                  label: 'Zapomniałem hasła',
                                  color: Palette.ivoryBlack,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            )),
          );
  }
}

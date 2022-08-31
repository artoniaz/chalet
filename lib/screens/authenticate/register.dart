import 'package:Challet/config/index.dart';
import 'package:Challet/screens/avatars/avatar_selection_container.dart';
import 'package:Challet/services/index.dart';
import 'package:Challet/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:Challet/styles/index.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController nickController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  String avatarId = '';
  String error = '';

  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  void _onTapAvatar(String choosenAvatarId) {
    setState(() => avatarId = choosenAvatarId);
    dissmissCurrentFocus(context);
  }

  Future registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate() && avatarId != '') {
      setState(() => isLoading = true);
      try {
        await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          passwordController.text.trim(),
          nickController.text.trim(),
          avatarId,
        );
      } catch (e) {
        setState(() {
          passwordController.clear();
          passwordRepeatController.clear();
          error = e.toString();
          isLoading = false;
        });
      }
    } else {
      setState(() {
        error = '';
      });
    }
  }

  void _changePasswordVisible() => setState(() => _isPasswordVisible = !_isPasswordVisible);
  void _changeRepeatPasswordVisible() => setState(() => _isRepeatPasswordVisible = !_isRepeatPasswordVisible);

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
                    padding: const EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding, vertical: 0.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            MainImage(),
                            Spacer(),
                            TextFormField(
                              controller: _emailController,
                              decoration: textInputDecoration.copyWith(hintText: 'Email'),
                              validator: (val) =>
                                  val!.isEmpty || !val.contains('@') ? 'Podaj poprawny adres email' : null,
                              onEditingComplete: () => node.nextFocus(),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            VerticalSizedBox16(),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: 'Pseudonim'),
                              validator: (val) => val!.length < 3 ? 'Pseudonim musi zawierać minimum 3 znaki' : null,
                              controller: nickController,
                              onEditingComplete: () => node.nextFocus(),
                            ),
                            VerticalSizedBox16(),
                            CustomPaswordTextField(
                              textEditingController: passwordController,
                              onEditingComplete: registerWithEmailAndPassword,
                              passwordVisible: _isPasswordVisible,
                              handlePasswordVisibleChange: _changePasswordVisible,
                            ),
                            VerticalSizedBox16(),
                            CustomPaswordTextField(
                              textEditingController: passwordRepeatController,
                              onEditingComplete: registerWithEmailAndPassword,
                              passwordVisible: _isRepeatPasswordVisible,
                              handlePasswordVisibleChange: _changeRepeatPasswordVisible,
                            ),
                            VerticalSizedBox16(),
                            AvatarSelectionContainer(
                              currentAvatarId: avatarId,
                              onTapAvatar: _onTapAvatar,
                            ),
                            VerticalSizedBox16(),
                            CustomElevatedButton(
                              label: 'Utwórz nowe konto',
                              onPressed: registerWithEmailAndPassword,
                            ),
                            if (error.isNotEmpty)
                              Column(
                                children: [
                                  VerticalSizedBox16(),
                                  Text(
                                    error,
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.errorRed),
                                  ),
                                  VerticalSizedBox16(),
                                ],
                              ),
                            Spacer(),
                            CustomTextButton(
                              onPressed: widget.toggleView,
                              label: 'Masz już konto? Zaloguj się.',
                              color: Palette.ivoryBlack,
                            )
                          ],
                        )),
                  ),
                ),
              ),
            )),
          );
  }
}

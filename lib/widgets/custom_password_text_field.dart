import 'package:chalet/styles/index.dart';
import 'package:flutter/material.dart';

class CustomPaswordTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onEditingComplete;
  final bool passwordVisible;
  final Function handlePasswordVisibleChange;

  const CustomPaswordTextField({
    Key? key,
    required this.textEditingController,
    required this.onEditingComplete,
    required this.passwordVisible,
    required this.handlePasswordVisibleChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: textInputDecoration.copyWith(
        hintText: 'Hasło',
        suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Palette.ivoryBlack,
            ),
            onPressed: () => handlePasswordVisibleChange()),
      ),
      obscureText: !passwordVisible,
      validator: (val) => val!.length < 6 ? 'Hasło musi zawierać minimum 6 znaków' : null,
      onEditingComplete: () => onEditingComplete(),
    );
  }
}

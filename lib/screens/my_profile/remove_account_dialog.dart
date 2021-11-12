import 'package:chalet/config/index.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/auth_service.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RemoveAccountDialog extends StatefulWidget {
  final String userEmail;
  const RemoveAccountDialog({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  _RemoveAccountDialogState createState() => _RemoveAccountDialogState();
}

class _RemoveAccountDialogState extends State<RemoveAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _removeAccout() async {
    try {
      if (_formKey.currentState!.validate()) {
        Navigator.of(context).pop();
        EasyLoading.show();
        bool res = await AuthService().deleteUser(widget.userEmail, _passwordController.text);
        if (res) {
          EasyLoading.showSuccess('Usunięto profil użytkownika');
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Czy na pewno chcesz usunąć swoje konto?',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              VerticalSizedBox16(),
              Text(
                'Wpisz hasło, aby potwierdzić usunięcie konta',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              VerticalSizedBox24(),
              TextFormField(
                controller: _passwordController,
                decoration: textInputDecoration.copyWith(hintText: 'Hasło'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Hasło musi zawierać minimum 6 znaków' : null,
              ),
              VerticalSizedBox24(),
              ButtonsPopUpRow(
                approveButtonLabel: 'Usuń konto',
                onPressedApproveButton: () => _removeAccout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

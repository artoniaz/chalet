import 'package:chalet/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:chalet/screens/index.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //this class detects if the user is loggedin and decides weather to show home or auth
    final user = Provider.of<UserModel?>(context);
    return user == null ? Authenticate() : Home();
  }
}

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:Challet/screens/index.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //this class detects if the user is loggedin and decides weather to show home or auth
    final user = Provider.of<firebaseAuth.User?>(context);
    return user == null ? Authenticate() : Home();
  }
}

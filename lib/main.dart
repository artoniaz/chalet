import 'package:chalet/config/custom_multi_bloc_provider.dart';
import 'package:chalet/config/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:chalet/styles/index.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<firebaseAuth.User?>.value(
      initialData: null,
      value: AuthService().user,
      child: CustomMultiBlocProvider(
        child: MaterialApp(
          title: 'Chalet app - find your own Chalet!',
          theme: themeData(),
          onGenerateRoute: onGenerateRoute(),
          builder: EasyLoading.init(),
          home: AuthWrapper(),
        ),
      ),
    );
  }
}

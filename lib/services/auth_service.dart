import 'package:chalet/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthService {
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;
  final fb = FacebookLogin();

  //auth change user stream
  Stream<UserModel?> get user {
    return _firebaseAuth
        .userChanges()
        // .authStateChanges()
        .map((firebseUser) => firebseUser != null ? UserModel.userModelFromFirebaseUser(firebseUser) : null);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      firebaseAuth.UserCredential authResult = await _firebaseAuth.signInAnonymously();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sing in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is firebaseAuth.FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          throw 'Zły format adresu email.';
        } else if (e.code == 'user-not-found') {
          throw 'Brak użytkownika o podanym adresie email.';
        } else {
          throw 'Niepoprawne dane do logowania.';
        }
      }
    }
  }

  //register with email and password
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is firebaseAuth.FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          throw 'Zły format adresu email.';
        } else if (e.code == 'email-already-exists') {
          throw 'Podany adres e-mail jest już używany przez istniejącego użytkownika.';
        } else {
          throw 'Niepoprawne dane do rejestracji';
        }
      }
    }
  }

  Future facebookAuth() async {
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (response.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken fbToken = response.accessToken!;
        final firebaseAuth.AuthCredential credential = firebaseAuth.FacebookAuthProvider.credential(fbToken.token);
        final result = await _firebaseAuth.signInWithCredential(credential);
        break;
      case FacebookLoginStatus.cancel:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  Future<void> editUserData(String displayName) async {
    try {
      await _firebaseAuth.currentUser!.updateProfile(displayName: displayName);
    } catch (e) {
      print(e);
      throw 'Nie udało się zaktualizować danych użytkownika';
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

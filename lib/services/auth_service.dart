import 'package:chalet/blocs/user_data/user_data_bloc.dart';
import 'package:chalet/blocs/user_data/user_data_event.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:provider/provider.dart';

class AuthService {
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;
  final fb = FacebookLogin();

  //auth change user stream
  Stream<firebaseAuth.User?> get user {
    return _firebaseAuth.userChanges();
    // .map((firebseUser) => firebseUser != null ? UserModel.userModelFromFirebaseUser(firebseUser) : null);
  }

  //sing in with email and password
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      firebaseAuth.UserCredential res =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is firebaseAuth.FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          throw 'Zły format adresu email.';
        } else if (e.code == 'user-not-found') {
          throw 'Brak użytkownika o podanym adresie email.';
        } else if (e.code == 'network-request-failed') {
          throw 'Brak połączenia z siecią. Sprawdź połaczenie z internetem.';
        } else {
          throw 'Niepoprawne dane do logowania.';
        }
      }
    }
  }

  //register with email and password
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String nick,
  ) async {
    try {
      firebaseAuth.UserCredential res =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await res.user?.updateDisplayName(nick);
      final userId = res.user!.uid;
      UserDataRepository().setUserDataOnRegister(userId, UserModel.fromData(userId, email, nick));
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
        await _firebaseAuth.signInWithCredential(credential);
        break;
      case FacebookLoginStatus.cancel:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Nie udało się zrestartować hasła';
    }
  }

  // Future<void> editUserData(String displayName) async {
  //   try {
  //     await _firebaseAuth.currentUser!.updateDisplayName(displayName);
  //   } catch (e) {
  //     print(e);
  //     throw 'Nie udało się zaktualizować danych użytkownika';
  //   }
  // }

  Future<void> changeUserPassword(String userEmail, String oldPassword, String newPassword) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: oldPassword);
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print(e);
      throw 'Nie udało się zaktualizować hasła';
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> deleteUser(String email, String password) async {
    try {
      firebaseAuth.User user = _firebaseAuth.currentUser!;
      firebaseAuth.AuthCredential credentials =
          firebaseAuth.EmailAuthProvider.credential(email: email, password: password);
      firebaseAuth.UserCredential result = await user.reauthenticateWithCredential(credentials);
      await result.user?.delete();
      return true;
    } catch (e) {
      print(e.toString());
      throw 'Nie udało się usunąć konta';
    }
  }
}

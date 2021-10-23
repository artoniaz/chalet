import 'package:chalet/models/user_model.dart';
import 'package:chalet/services/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class AuthService {
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;

  //create UserModel based on FirebaseUser
  UserModel? _userModelFromFirebaseUser(firebaseAuth.User? firebaseUser) {
    return firebaseUser != null ? UserModel(uid: firebaseUser.uid) : null;
  }

  //auth change user stream
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map(_userModelFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      firebaseAuth.UserCredential authResult = await _firebaseAuth.signInAnonymously();
      return _userModelFromFirebaseUser(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sing in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebaseAuth.UserCredential result =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userModelFromFirebaseUser(result.user);
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
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      firebaseAuth.UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userModelFromFirebaseUser(result.user);
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

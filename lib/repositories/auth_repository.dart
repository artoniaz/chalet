import 'package:Challet/services/auth_service.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<void> signInWithEmailAndPassword(String email, String password) =>
      _authService.signInWithEmailAndPassword(email, password);
}

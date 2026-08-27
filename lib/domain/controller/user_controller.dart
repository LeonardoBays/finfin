import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  const UserController(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  User getUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw "Usuário não encontrado";
    }

    return user;
  }
}

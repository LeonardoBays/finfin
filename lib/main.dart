import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'injector.dart';

void main() async {
  final injector = await _initializeApp();

  runApp(App(injector: injector));
}

Future<Injector> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final injector = await InjectorImpl.initializeDependencies();

  // final user = FirebaseAuth.instance.currentUser;
  // print('user: ${user?.uid}');

  return injector;
}

// Future<UserCredential> _register({
//   required String email,
//   required String password,
// }) async {
//   return await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     email: email,
//     password: password,
//   );
// }
//
// Future<UserCredential> _signIn({
//   required String email,
//   required String password,
// }) async {
//   return await FirebaseAuth.instance.signInWithEmailAndPassword(
//     email: email,
//     password: password,
//   );
// }

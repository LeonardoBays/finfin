import 'package:firebase_auth/firebase_auth.dart';
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

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    const email = "superemail@gmail.com";
    const password = '123456';

    await _register(email: email, password: password);
    await _signIn(email: email, password: password);
  }

  return injector;
}

Future<UserCredential> _register({
  required String email,
  required String password,
}) async {
  return await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<UserCredential> _signIn({
  required String email,
  required String password,
}) async {
  return await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

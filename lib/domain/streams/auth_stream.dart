import 'dart:async';

import '../../presentation/screens/authentication/bloc/authentication_bloc.dart';

class AuthStream {
  AuthStream();

  final StreamController<AuthStatus> _authStream = StreamController.broadcast();

  Stream<AuthStatus> get stream => _authStream.stream;

  void addAuthStatus(AuthStatus status) => _authStream.add(status);

  void dispose() => _authStream.close();
}

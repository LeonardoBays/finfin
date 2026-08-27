import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain/streams/auth_stream.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authStream)
    : super(const AuthenticationState.authenticating()) {
    _initializeAuthStream();
    on<AuthenticationStatusChange>(_onAuthenticationStatusChange);
  }

  final AuthStream _authStream;
  late final StreamSubscription _authSubscription;

  FutureOr<void> _onAuthenticationStatusChange(
    AuthenticationStatusChange event,
    Emitter<AuthenticationState> emit,
  ) async {
    final state = switch (event.authStatus) {
      AuthStatus.unauthenticated => const AuthenticationState.unauthenticated(),
      AuthStatus.authenticating => const AuthenticationState.authenticating(),
      AuthStatus.authenticated => const AuthenticationState.authenticated(),
    };

    emit(state);
  }

  void _initializeAuthStream() {
    _authSubscription = _authStream.stream.listen((status) {
      add(AuthenticationStatusChange(status));
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _authStream.dispose();
    return super.close();
  }
}

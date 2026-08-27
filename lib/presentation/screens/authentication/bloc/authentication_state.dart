part of 'authentication_bloc.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.authStatus = AuthStatus.authenticating,
  });

  const AuthenticationState.unauthenticated()
      : this._(authStatus: AuthStatus.unauthenticated);

  const AuthenticationState.authenticated()
      : this._(authStatus: AuthStatus.authenticated);

  const AuthenticationState.authenticating() : this._();

  final AuthStatus authStatus;

  bool get isAuthenticated => authStatus == AuthStatus.authenticated;

  bool get isAuthenticating => authStatus == AuthStatus.authenticating;

  bool get isUnauthenticated => authStatus == AuthStatus.unauthenticated;

  @override
  List<Object?> get props => [authStatus];
}

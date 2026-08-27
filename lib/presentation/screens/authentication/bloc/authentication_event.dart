part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

final class AuthenticationRefresh extends AuthenticationEvent {
  const AuthenticationRefresh();

  @override
  List<Object> get props => [];
}

final class AuthenticationStatusChange extends AuthenticationEvent {
  const AuthenticationStatusChange(this.authStatus);

  final AuthStatus authStatus;

  @override
  List<Object> get props => [authStatus];
}

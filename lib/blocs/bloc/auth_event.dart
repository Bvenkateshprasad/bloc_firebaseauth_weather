part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

final class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested({
    required this.email,
    required this.password,
  });
}

final class AuthLogoutRequested extends AuthEvent {}

final class Splash extends AuthEvent {}

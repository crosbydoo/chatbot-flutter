part of 'login_bloc.dart';

abstract class AuthLoginEvent extends Equatable {
  const AuthLoginEvent();
}

class AuthLoginInitEvent extends AuthLoginEvent {
  @override
  List<Object?> get props => [];
}

class AuthLoginPostEvent extends AuthLoginEvent {
  final String username;
  final String password;

  const AuthLoginPostEvent({
    this.username = '',
    this.password = '',
  });

  @override
  List<Object?> get props => [username, password];
}

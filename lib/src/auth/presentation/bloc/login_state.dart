part of 'login_bloc.dart';

class AuthLoginStateData extends Equatable {
  final LoginDto user;
  final ErrorDto? error;

  const AuthLoginStateData({
    this.user = const LoginDto(),
    this.error,
  });

  @override
  List<Object?> get props => [user, error];

  AuthLoginStateData copyWith({
    ErrorDto? error,
    LoginDto? user,
  }) {
    return AuthLoginStateData(
      user: user ?? this.user,
      error: error,
    );
  }
}

abstract class AuthLoginState extends Equatable {
  final AuthLoginStateData data;

  const AuthLoginState(this.data);

  @override
  List<Object> get props => [data];
}

class AuthLoginInitialState extends AuthLoginState {
  const AuthLoginInitialState() : super(const AuthLoginStateData());
}

class AuthLoginLoadingState extends AuthLoginState {
  const AuthLoginLoadingState(super.data);
}

class AuthLoginSuccessState extends AuthLoginState {
  const AuthLoginSuccessState(super.data);
}

class AuthLoginFailedState extends AuthLoginState {
  const AuthLoginFailedState(super.data);
}

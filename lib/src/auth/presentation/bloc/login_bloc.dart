import 'package:bloc/bloc.dart';
import 'package:chatbot/core/data/local/app_preferences.dart';
import 'package:chatbot/core/domain/models/error_dto.dart';
import 'package:chatbot/src/auth/data/remote/requests/login_request.dart';
import 'package:chatbot/src/auth/domain/models/login_dto.dart';
import 'package:chatbot/src/auth/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<AuthLoginEvent, AuthLoginState> {
  final LoginUseCase loginUseCase;
  final AppPreferences preferences;
  var stateData = const AuthLoginStateData();

  LoginBloc({
    required this.loginUseCase,
    required this.preferences,
  }) : super(const AuthLoginInitialState()) {
    on<AuthLoginInitEvent>(_onInit);
    on<AuthLoginPostEvent>(_postLogin);
  }

  void _onInit(
    AuthLoginInitEvent event,
    Emitter<AuthLoginState> emit,
  ) {
    emit(const AuthLoginInitialState());
  }

  void _postLogin(
    AuthLoginPostEvent event,
    Emitter<AuthLoginState> emit,
  ) async {
    emit(AuthLoginLoadingState(stateData));

    var loginBody = LoginRequest(
      username: event.username,
      password: event.password,
    );

    var resultLogin = await loginUseCase.execute(loginBody);

    resultLogin.fold((ErrorDto error) {
      stateData = stateData.copyWith(
        user: const LoginDto(),
        error: error,
      );
      emit(AuthLoginFailedState(stateData));
    }, (login) {
      stateData = stateData.copyWith(
        user: login,
        error: null,
      );
      emit(AuthLoginSuccessState(stateData));
    });
  }
}

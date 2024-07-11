import 'package:chatbot/di.dart';
import 'package:chatbot/src/auth/data/remote/services/auth_service.dart';
import 'package:chatbot/src/auth/data/repository/auth_repository.dart';
import 'package:chatbot/src/auth/data/repository/auth_repository_impl.dart';
import 'package:chatbot/src/auth/domain/usecases/login_usecase.dart';
import 'package:chatbot/src/auth/presentation/bloc/login_bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthDiModule {
  @singleton
  AuthService authService(Dio dio) => AuthService(dio);

  @Singleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  @injectable
  LoginUseCase loginUseCase(AuthRepository repository) =>
      LoginUseCase(repository);

  @injectable
  LoginBloc loginBloc(LoginUseCase loginUseCase) => LoginBloc(
        loginUseCase: LoginUseCase(sl()),
        preferences: sl(),
      );
}

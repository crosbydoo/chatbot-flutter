import 'package:chatbot/core/utils/future_util.dart';
import 'package:chatbot/core/utils/typedef_util.dart';
import 'package:chatbot/src/auth/data/remote/requests/login_request.dart';
import 'package:chatbot/src/auth/data/remote/responses/login_response.dart';
import 'package:chatbot/src/auth/data/remote/services/auth_service.dart';
import 'package:chatbot/src/auth/data/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  FutureOrError<LoginResponse> login(LoginRequest request) {
    return callOrError(() => authService.login(request));
  }
}

import 'package:chatbot/core/utils/typedef_util.dart';
import 'package:chatbot/src/auth/data/remote/requests/login_request.dart';
import 'package:chatbot/src/auth/data/remote/responses/login_response.dart';

abstract class AuthRepository {
  FutureOrError<LoginResponse> login(LoginRequest request);
}

import 'package:chatbot/core/utils/typedef_util.dart';
import 'package:chatbot/src/auth/data/remote/requests/login_request.dart';
import 'package:chatbot/src/auth/data/repository/auth_repository.dart';
import 'package:chatbot/src/auth/domain/mapper/login_mapper.dart';
import 'package:either_dart/either.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  FutureOrError execute(LoginRequest request) {
    return repository.login(request).mapRight((response) {
      var result = response.toDto();
      return result;
    });
  }
}
